/**
 * QR Code encoder - byte mode, versões 1..10, níveis L/M/Q/H
 *
 * ENG-2981: a loading roda dentro do FiveM com a CSP declarada no index.html
 * (`img-src 'self' ... data:`, `connect-src` sem hosts públicos). Isso descarta
 * qualquer serviço externo de QR — o código precisa ser gerado no próprio
 * cliente a partir do deep link que o jogo manda.
 *
 * Expõe `window.SantaQR`:
 *   SantaQR.matrix(text, level) -> Array<Array<boolean>> (true = módulo escuro)
 *   SantaQR.svg(text, options)  -> string com o <svg> pronto pra innerHTML
 */
(function (global) {
    'use strict';

    // ===== GF(256), polinômio primitivo 0x11D =====
    var EXP = new Uint8Array(256);
    var LOG = new Uint8Array(256);

    (function buildTables() {
        var x = 1;
        for (var i = 0; i < 255; i++) {
            EXP[i] = x;
            LOG[x] = i;
            x <<= 1;
            if (x & 0x100) x ^= 0x11D;
        }
        EXP[255] = EXP[0];
    })();

    function gexp(n) {
        while (n < 0) n += 255;
        while (n >= 255) n -= 255;
        return EXP[n];
    }

    function gmul(a, b) {
        if (a === 0 || b === 0) return 0;
        return EXP[(LOG[a] + LOG[b]) % 255];
    }

    function polyMultiply(a, b) {
        var result = new Array(a.length + b.length - 1);
        for (var i = 0; i < result.length; i++) result[i] = 0;
        for (var j = 0; j < a.length; j++) {
            for (var k = 0; k < b.length; k++) {
                result[j + k] ^= gmul(a[j], b[k]);
            }
        }
        return result;
    }

    /** Polinômio gerador de Reed-Solomon para `count` codewords de correção. */
    function rsGenerator(count) {
        var poly = [1];
        for (var i = 0; i < count; i++) poly = polyMultiply(poly, [1, gexp(i)]);
        return poly;
    }

    /** Divisão sintética: devolve só o resto (os codewords de correção). */
    function rsEncode(data, ecCount) {
        var gen = rsGenerator(ecCount);
        var buffer = new Array(data.length + ecCount);
        var i;
        for (i = 0; i < data.length; i++) buffer[i] = data[i];
        for (i = data.length; i < buffer.length; i++) buffer[i] = 0;

        for (i = 0; i < data.length; i++) {
            var coef = buffer[i];
            if (coef === 0) continue;
            for (var j = 0; j < gen.length; j++) {
                buffer[i + j] ^= gmul(gen[j], coef);
            }
        }
        return buffer.slice(data.length);
    }

    // ===== Tabelas do padrão =====

    // Bits do indicador de nível de correção no format info.
    var EC_LEVEL_BITS = { L: 1, M: 0, Q: 3, H: 2 };
    // Índice do nível dentro de RS_BLOCK_TABLE.
    var EC_LEVEL_INDEX = { L: 0, M: 1, Q: 2, H: 3 };

    // [blocos, codewords totais, codewords de dados] por versão × nível (L,M,Q,H).
    var RS_BLOCK_TABLE = [
        // v1
        [1, 26, 19], [1, 26, 16], [1, 26, 13], [1, 26, 9],
        // v2
        [1, 44, 34], [1, 44, 28], [1, 44, 22], [1, 44, 16],
        // v3
        [1, 70, 55], [1, 70, 44], [2, 35, 17], [2, 35, 13],
        // v4
        [1, 100, 80], [2, 50, 32], [2, 50, 24], [4, 25, 9],
        // v5
        [1, 134, 108], [2, 67, 43], [2, 33, 15, 2, 34, 16], [2, 33, 11, 2, 34, 12],
        // v6
        [2, 86, 68], [4, 43, 27], [4, 43, 19], [4, 43, 15],
        // v7
        [2, 98, 78], [4, 49, 31], [2, 32, 14, 4, 33, 15], [4, 39, 13, 1, 40, 14],
        // v8
        [2, 121, 97], [2, 60, 38, 2, 61, 39], [4, 40, 18, 2, 41, 19], [4, 40, 14, 2, 41, 15],
        // v9
        [2, 146, 116], [3, 58, 36, 2, 59, 37], [4, 36, 16, 4, 37, 17], [4, 36, 12, 4, 37, 13],
        // v10
        [2, 86, 68, 2, 87, 69], [4, 69, 43, 1, 70, 44], [6, 43, 19, 2, 44, 20], [6, 43, 15, 2, 44, 16]
    ];

    var MAX_VERSION = 10;

    // Centros dos padrões de alinhamento por versão (índice 0 = v1).
    var ALIGNMENT_POSITIONS = [
        [],
        [6, 18],
        [6, 22],
        [6, 26],
        [6, 30],
        [6, 34],
        [6, 22, 38],
        [6, 24, 42],
        [6, 26, 46],
        [6, 28, 50]
    ];

    var G15 = 0x537;        // 10100110111
    var G15_MASK = 0x5412;  // 101010000010010
    var G18 = 0x1F25;       // 1111100100101

    function bchDigit(data) {
        var digit = 0;
        while (data !== 0) {
            digit++;
            data >>>= 1;
        }
        return digit;
    }

    function bchTypeInfo(data) {
        var d = data << 10;
        while (bchDigit(d) - bchDigit(G15) >= 0) {
            d ^= (G15 << (bchDigit(d) - bchDigit(G15)));
        }
        return ((data << 10) | d) ^ G15_MASK;
    }

    function bchTypeNumber(data) {
        var d = data << 12;
        while (bchDigit(d) - bchDigit(G18) >= 0) {
            d ^= (G18 << (bchDigit(d) - bchDigit(G18)));
        }
        return (data << 12) | d;
    }

    function maskAt(pattern, i, j) {
        switch (pattern) {
            case 0: return (i + j) % 2 === 0;
            case 1: return i % 2 === 0;
            case 2: return j % 3 === 0;
            case 3: return (i + j) % 3 === 0;
            case 4: return (Math.floor(i / 2) + Math.floor(j / 3)) % 2 === 0;
            case 5: return ((i * j) % 2) + ((i * j) % 3) === 0;
            case 6: return (((i * j) % 2) + ((i * j) % 3)) % 2 === 0;
            case 7: return (((i * j) % 3) + ((i + j) % 2)) % 2 === 0;
            default: return false;
        }
    }

    // ===== Codificação dos dados =====

    /** UTF-8, porque o deep link pode carregar querystring com acento. */
    function toUtf8Bytes(text) {
        var bytes = [];
        for (var i = 0; i < text.length; i++) {
            var code = text.charCodeAt(i);
            if (code < 0x80) {
                bytes.push(code);
            } else if (code < 0x800) {
                bytes.push(0xC0 | (code >> 6), 0x80 | (code & 0x3F));
            } else if (code < 0xD800 || code >= 0xE000) {
                bytes.push(0xE0 | (code >> 12), 0x80 | ((code >> 6) & 0x3F), 0x80 | (code & 0x3F));
            } else {
                // par surrogate
                i++;
                var full = 0x10000 + (((code & 0x3FF) << 10) | (text.charCodeAt(i) & 0x3FF));
                bytes.push(
                    0xF0 | (full >> 18),
                    0x80 | ((full >> 12) & 0x3F),
                    0x80 | ((full >> 6) & 0x3F),
                    0x80 | (full & 0x3F)
                );
            }
        }
        return bytes;
    }

    function rsBlocksFor(version, level) {
        var row = RS_BLOCK_TABLE[(version - 1) * 4 + EC_LEVEL_INDEX[level]];
        var blocks = [];
        for (var i = 0; i < row.length; i += 3) {
            for (var j = 0; j < row[i]; j++) {
                blocks.push({ total: row[i + 1], data: row[i + 2] });
            }
        }
        return blocks;
    }

    function dataCapacityBytes(version, level) {
        var blocks = rsBlocksFor(version, level);
        var total = 0;
        for (var i = 0; i < blocks.length; i++) total += blocks[i].data;
        // 4 bits de modo + indicador de tamanho (8 bits até a v9, 16 daí em diante)
        var headerBits = 4 + (version < 10 ? 8 : 16);
        return Math.floor((total * 8 - headerBits) / 8);
    }

    function pickVersion(byteLength, level) {
        for (var v = 1; v <= MAX_VERSION; v++) {
            if (dataCapacityBytes(v, level) >= byteLength) return v;
        }
        return -1;
    }

    /** Monta o fluxo final de codewords já intercalado (dados + correção). */
    function buildCodewords(bytes, version, level) {
        var blocks = rsBlocksFor(version, level);
        var totalData = 0;
        var i, j;
        for (i = 0; i < blocks.length; i++) totalData += blocks[i].data;

        var bits = [];
        function push(value, length) {
            for (var b = length - 1; b >= 0; b--) bits.push((value >>> b) & 1);
        }

        push(4, 4); // modo byte
        push(bytes.length, version < 10 ? 8 : 16);
        for (i = 0; i < bytes.length; i++) push(bytes[i], 8);

        // terminador (até 4 bits) + alinhamento de byte
        var maxBits = totalData * 8;
        for (i = 0; i < 4 && bits.length < maxBits; i++) bits.push(0);
        while (bits.length % 8 !== 0) bits.push(0);

        var data = [];
        for (i = 0; i < bits.length; i += 8) {
            var byte = 0;
            for (j = 0; j < 8; j++) byte = (byte << 1) | bits[i + j];
            data.push(byte);
        }
        // preenchimento alternado 0xEC / 0x11
        var pad = [0xEC, 0x11];
        for (i = 0; data.length < totalData; i++) data.push(pad[i % 2]);

        // divide em blocos e calcula a correção de cada um
        var dataBlocks = [];
        var ecBlocks = [];
        var offset = 0;
        var maxDataLength = 0;
        var maxEcLength = 0;
        for (i = 0; i < blocks.length; i++) {
            var chunk = data.slice(offset, offset + blocks[i].data);
            offset += blocks[i].data;
            dataBlocks.push(chunk);
            var ec = rsEncode(chunk, blocks[i].total - blocks[i].data);
            ecBlocks.push(ec);
            maxDataLength = Math.max(maxDataLength, chunk.length);
            maxEcLength = Math.max(maxEcLength, ec.length);
        }

        var out = [];
        for (i = 0; i < maxDataLength; i++) {
            for (j = 0; j < dataBlocks.length; j++) {
                if (i < dataBlocks[j].length) out.push(dataBlocks[j][i]);
            }
        }
        for (i = 0; i < maxEcLength; i++) {
            for (j = 0; j < ecBlocks.length; j++) {
                if (i < ecBlocks[j].length) out.push(ecBlocks[j][i]);
            }
        }
        return out;
    }

    // ===== Montagem da matriz =====

    function makeGrid(size) {
        var grid = new Array(size);
        for (var i = 0; i < size; i++) {
            grid[i] = new Array(size);
            for (var j = 0; j < size; j++) grid[i][j] = null;
        }
        return grid;
    }

    function setupFinder(grid, row, col) {
        var size = grid.length;
        for (var r = -1; r <= 7; r++) {
            for (var c = -1; c <= 7; c++) {
                if (row + r < 0 || size <= row + r || col + c < 0 || size <= col + c) continue;
                var on =
                    (r >= 0 && r <= 6 && (c === 0 || c === 6)) ||
                    (c >= 0 && c <= 6 && (r === 0 || r === 6)) ||
                    (r >= 2 && r <= 4 && c >= 2 && c <= 4);
                grid[row + r][col + c] = on;
            }
        }
    }

    function setupTiming(grid) {
        var size = grid.length;
        for (var i = 8; i < size - 8; i++) {
            if (grid[i][6] === null) grid[i][6] = i % 2 === 0;
            if (grid[6][i] === null) grid[6][i] = i % 2 === 0;
        }
    }

    function setupAlignment(grid, version) {
        var pos = ALIGNMENT_POSITIONS[version - 1];
        for (var i = 0; i < pos.length; i++) {
            for (var j = 0; j < pos.length; j++) {
                var row = pos[i];
                var col = pos[j];
                if (grid[row][col] !== null) continue; // colide com um finder
                for (var r = -2; r <= 2; r++) {
                    for (var c = -2; c <= 2; c++) {
                        grid[row + r][col + c] =
                            r === -2 || r === 2 || c === -2 || c === 2 || (r === 0 && c === 0);
                    }
                }
            }
        }
    }

    function setupTypeInfo(grid, level, mask) {
        var size = grid.length;
        var bits = bchTypeInfo((EC_LEVEL_BITS[level] << 3) | mask);
        var i, on;

        for (i = 0; i < 15; i++) {
            on = ((bits >> i) & 1) === 1;
            if (i < 6) grid[i][8] = on;
            else if (i < 8) grid[i + 1][8] = on;
            else grid[size - 15 + i][8] = on;
        }
        for (i = 0; i < 15; i++) {
            on = ((bits >> i) & 1) === 1;
            if (i < 8) grid[8][size - i - 1] = on;
            else if (i < 9) grid[8][15 - i - 1 + 1] = on;
            else grid[8][15 - i - 1] = on;
        }
        grid[size - 8][8] = true; // módulo escuro fixo
    }

    function setupVersionInfo(grid, version) {
        if (version < 7) return;
        var size = grid.length;
        var bits = bchTypeNumber(version);
        for (var i = 0; i < 18; i++) {
            var on = ((bits >> i) & 1) === 1;
            grid[Math.floor(i / 3)][(i % 3) + size - 8 - 3] = on;
            grid[(i % 3) + size - 8 - 3][Math.floor(i / 3)] = on;
        }
    }

    function mapData(grid, codewords, mask) {
        var size = grid.length;
        var inc = -1;
        var row = size - 1;
        var bitIndex = 7;
        var byteIndex = 0;

        for (var col = size - 1; col > 0; col -= 2) {
            if (col === 6) col--;
            for (;;) {
                for (var c = 0; c < 2; c++) {
                    if (grid[row][col - c] !== null) continue;
                    var dark = false;
                    if (byteIndex < codewords.length) {
                        dark = ((codewords[byteIndex] >>> bitIndex) & 1) === 1;
                    }
                    if (maskAt(mask, row, col - c)) dark = !dark;
                    grid[row][col - c] = dark;
                    bitIndex--;
                    if (bitIndex === -1) {
                        byteIndex++;
                        bitIndex = 7;
                    }
                }
                row += inc;
                if (row < 0 || size <= row) {
                    row -= inc;
                    inc = -inc;
                    break;
                }
            }
        }
    }

    // Regra 3 da penalidade: proporção 1:1:3:1:1 (`1011101`) com quatro módulos
    // claros de um dos lados. Junto à borda do símbolo a zona clara pode ser
    // menor que 4 — a margem branca do símbolo completa o padrão.
    var PENALTY_PATTERN = '1011101';

    function isAllLight(line, from, to) {
        for (var i = Math.max(from, 0); i < Math.min(to, line.length); i++) {
            if (line[i] === '1') return false;
        }
        return true;
    }

    function n3Score(line) {
        var score = 0;
        var idx = line.indexOf(PENALTY_PATTERN);
        while (idx !== -1) {
            var after = idx + 7;
            if (isAllLight(line, idx - 4, idx) || isAllLight(line, after, after + 4)) {
                score += 40;
                idx = line.indexOf(PENALTY_PATTERN, after);
            } else {
                // sem zona clara suficiente: o próximo casamento possível só
                // pode começar no módulo escuro central deste
                idx = line.indexOf(PENALTY_PATTERN, idx + 4);
            }
        }
        return score;
    }

    /**
     * Pontuação das 4 regras de penalidade (ISO/IEC 18004) — menor é melhor.
     * @returns {[number, number, number, number]} N1, N2, N3 e N4 separados
     */
    function penaltyParts(grid) {
        var size = grid.length;
        var scoreN1 = 0;
        var scoreN2 = 0;
        var scoreN3 = 0;
        var row, col, i;

        // Serializa linhas e colunas uma vez só: as regras 1 e 3 varrem as duas.
        var rows = new Array(size);
        var cols = new Array(size);
        for (row = 0; row < size; row++) {
            var rowChars = new Array(size);
            for (col = 0; col < size; col++) rowChars[col] = grid[row][col] ? '1' : '0';
            rows[row] = rowChars.join('');
        }
        for (col = 0; col < size; col++) {
            var colChars = new Array(size);
            for (row = 0; row < size; row++) colChars[row] = grid[row][col] ? '1' : '0';
            cols[col] = colChars.join('');
        }

        // regra 1: sequências de 5+ módulos da mesma cor → 3 + (tamanho - 5)
        var lines = rows.concat(cols);
        for (i = 0; i < lines.length; i++) {
            var line = lines[i];
            var runLength = 1;
            for (var k = 1; k <= line.length; k++) {
                if (k < line.length && line[k] === line[k - 1]) {
                    runLength++;
                    continue;
                }
                if (runLength >= 5) scoreN1 += 3 + (runLength - 5);
                runLength = 1;
            }
        }

        // regra 2: blocos 2x2 de uma cor só
        for (row = 0; row < size - 1; row++) {
            for (col = 0; col < size - 1; col++) {
                var count = 0;
                if (grid[row][col]) count++;
                if (grid[row + 1][col]) count++;
                if (grid[row][col + 1]) count++;
                if (grid[row + 1][col + 1]) count++;
                if (count === 0 || count === 4) scoreN2 += 3;
            }
        }

        // regra 3
        for (i = 0; i < lines.length; i++) scoreN3 += n3Score(lines[i]);

        // regra 4: desvio da proporção de 50% de módulos escuros
        var darkCount = 0;
        for (row = 0; row < size; row++) {
            for (col = 0; col < size; col++) {
                if (grid[row][col]) darkCount++;
            }
        }
        var percent = (darkCount * 100) / (size * size);
        var scoreN4 = Math.floor(Math.abs(percent - 50) / 5) * 10;

        return [scoreN1, scoreN2, scoreN3, scoreN4];
    }

    function penalty(grid) {
        var parts = penaltyParts(grid);
        return parts[0] + parts[1] + parts[2] + parts[3];
    }

    function buildWithMask(codewords, version, level, mask) {
        var size = version * 4 + 17;
        var grid = makeGrid(size);
        setupFinder(grid, 0, 0);
        setupFinder(grid, size - 7, 0);
        setupFinder(grid, 0, size - 7);
        setupAlignment(grid, version);
        setupTiming(grid);
        setupTypeInfo(grid, level, mask);
        setupVersionInfo(grid, version);
        mapData(grid, codewords, mask);
        return grid;
    }

    /**
     * Gera a matriz de módulos do QR.
     * @param {string} text conteúdo (o deep link enviado pelo jogo)
     * @param {'L'|'M'|'Q'|'H'} [level='H'] nível de correção
     * @returns {Array<Array<boolean>>} true = módulo escuro
     */
    function matrix(text, level) {
        level = EC_LEVEL_BITS[level] === undefined ? 'H' : level;
        var bytes = toUtf8Bytes(String(text));
        var version = pickVersion(bytes.length, level);
        if (version === -1) {
            throw new Error('SantaQR: conteúdo maior do que a versão ' + MAX_VERSION + ' suporta');
        }

        var codewords = buildCodewords(bytes, version, level);

        var best = null;
        var bestScore = Infinity;
        for (var mask = 0; mask < 8; mask++) {
            var grid = buildWithMask(codewords, version, level, mask);
            var score = penalty(grid);
            if (score < bestScore) {
                bestScore = score;
                best = grid;
            }
        }
        return best;
    }

    /**
     * Renderiza o QR como SVG. Sem borda branca extra: quem dá a "quiet zone"
     * é o padding do container (o `QR block` do Figma tem 7,65px de padding).
     * @param {string} text
     * @param {{level?:string, margin?:number, dark?:string, light?:string, className?:string}} [options]
     */
    function svg(text, options) {
        options = options || {};
        var grid = matrix(text, options.level || 'H');
        var margin = options.margin === undefined ? 0 : options.margin;
        var size = grid.length;
        var total = size + margin * 2;
        var dark = options.dark || '#0D0D0D';
        var light = options.light || 'transparent';
        var parts = [];

        for (var row = 0; row < size; row++) {
            var col = 0;
            while (col < size) {
                if (!grid[row][col]) {
                    col++;
                    continue;
                }
                var runStart = col;
                while (col < size && grid[row][col]) col++;
                // um <rect> por sequência horizontal: menos nós e sem costura entre módulos
                parts.push(
                    '<rect x="' + (runStart + margin) + '" y="' + (row + margin) +
                    '" width="' + (col - runStart) + '" height="1" fill="' + dark + '"/>'
                );
            }
        }

        return (
            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ' + total + ' ' + total + '"' +
            ' shape-rendering="crispEdges" preserveAspectRatio="xMidYMid meet"' +
            (options.className ? ' class="' + options.className + '"' : '') +
            ' role="img" aria-label="QR Code de vínculo">' +
            (light === 'transparent' ? '' : '<rect width="' + total + '" height="' + total + '" fill="' + light + '"/>') +
            parts.join('') +
            '</svg>'
        );
    }

    var SantaQR = {
        matrix: matrix,
        svg: svg,
        MAX_VERSION: MAX_VERSION,
        // Exposto só para os testes de conformidade (comparação com uma
        // implementação de referência); nada da UI usa isto.
        _internals: {
            toUtf8Bytes: toUtf8Bytes,
            pickVersion: pickVersion,
            buildCodewords: buildCodewords,
            buildWithMask: buildWithMask,
            penalty: penalty,
            penaltyParts: penaltyParts
        }
    };

    global.SantaQR = SantaQR;
    if (typeof module !== 'undefined' && module.exports) module.exports = SantaQR;
})(typeof window !== 'undefined' ? window : globalThis);
