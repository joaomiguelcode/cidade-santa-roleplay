/**
 * City Configuration Manager - Complete Configuration
 * Contains all configurations for each city: video, music, slides, keyboard, social links
 * Backend only needs to send: cityName and progress
 */

class CityConfigManager {
    constructor() {
        // Central CDN configuration - One unique place for all links
        this.cdnBase = 'https://santaloading.roleplayrp.com';
        this.seasonPath = 'newloading';
        this.legacyPath = 'newloading';

        // Links da Santa Group para cidades brasileiras
        this.santaGroupLinks = {
            instagram: 'https://www.instagram.com/santagroup.gg/',
            tiktok: 'https://www.tiktok.com/@santagroup_gg',
            youtube: 'https://www.youtube.com/@SantaGroupRP/shorts'
        };

        this.configs = {
            "Universo": {
                video: `${this.cdnBase}/img/${this.seasonPath}/Universo/loading.mp4`,
                image: `${this.cdnBase}/img/${this.seasonPath}/Universo/banner_cd.png`,
                audio: `${this.cdnBase}/img/${this.seasonPath}/Universo/universo.mp3`,
                trackArtist: "Cidade Universo",
                slides: [
                    {
                        title: "SEJA GENTE BOA",
                        description: "🤝 Seja educado, respeite todos e principalmente os iniciantes<br> e jogue limpo. A Cidade Universo é um RP de respeito e diversão!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 490.webp",
                        alt: "Seja Gente Boa - Regras de comportamento",
                        city: "Universo"
                    },
                    {
                        title: "USO DE ARMAS",
                        description: "⚔️ O uso de armas na Cidade Universo é dividida em duas zonas:<br> Norte: uso liberado de todas as armas.<br> Sul: permitido apenas pistolas.<br> ⚠️ Armas pesadas no Sul podem gerar punições.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 491.webp",
                        alt: "Regras de uso de armas",
                        city: "Universo"
                    },
                    {
                        title: "DESCE E QUEBRA",
                        description: "⚔️ Desce e quebra é permitido em áreas remotas, excluindo<br> vias principais da cidade. Permitido desce e quebra apenas em<br> becos, vielas, garagens e interiores.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 492.webp",
                        alt: "Regras de desce e quebra",
                        city: "Universo"
                    },
                    {
                        title: "DICAS",
                        description: "🚗 Quer comprar o seu primeiro veículo?<br> Vá até a Concessionária da Cidade Universo e escolha o modelo<br> que mais combina com você.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 493.webp",
                        alt: "Dicas - Comprar veículo",
                        city: "Universo"
                    },
                    {
                        title: "DICAS",
                        description: "💰 Quer lucrar enquanto relaxa?<br> Fique AFK nos farms de pesca ou de leite espalhados pela<br> cidade. Quanto mais tempo ativo, maior o seu ganho!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 494.webp",
                        alt: "Dicas - Farms e ganhos",
                        city: "Universo"
                    },
                    {
                        title: "AJUDA",
                        description: "💡 Teve algum problema ou dúvida?<br> Aperte F5 para abrir um chamado com a equipe da Cidade<br> Universo. Nosso suporte está sempre pronto pra te ajudar!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 495.webp",
                        alt: "Como obter ajuda",
                        city: "Universo"
                    }
                ],
                keyboardConfig: {
                    'esc': 'Use para abrir o Menu principal',
                    'f5': 'Use para abrir um chamado de ajuda',
                    'tab': 'Use para acessar a Hotbar de itens',
                    'caps-lock': 'Segure para falar na rádio conectada.',
                    'r': 'Use para recarregar a sua arma equipada.',
                    't': 'Use para abrir o chat',
                    'p': 'Use para abrir o mapa',
                    'k': 'Use para usar o celular',
                    'home': 'Use para aumentar/dimunuir o volume do microfone',
                    'quote': 'Use para abrir o seu inventário'
                },
                socialLinks: {
                    youtube: 'https://www.youtube.com/@CidadeUniversoRP',
                    instagram: 'https://www.instagram.com/cidadeuniverso.gg/',
                    discord: 'https://discord.gg/universorp',
                    tiktok: 'https://www.tiktok.com/@cidadeuniverso'
                },
                staticTexts: {
                    welcomeText: 'Bem vindo a',
                    socialMediaTitle: 'Redes Sociais',
                    loadingText: 'Estamos carregando todo o seu mapa',
                    ratingTitle: 'CLASSIFICAÇÃO INDICATIVA',
                    ratingReasons: 'Violência, Drogas, Conteúdo sexual',
                    shortcutsDescription: 'Passe o mouse sobre as teclas destacadas para saber mais',
                    shortcutsButtonText: 'Ver Atalhos'
                }
            },
            "Malta": {
                video: `${this.cdnBase}/img/${this.seasonPath}/Malta/malta.mp4`,
                image: `${this.cdnBase}/img/${this.seasonPath}/Malta/banner_cd.png`,
                audio: `${this.cdnBase}/img/${this.seasonPath}/Malta/malta.mp3`,
                trackArtist: "Malta Rp",
                slides: [
                    {
                        title: "SEJA GENTE BOA",
                        description: "🤝 Seja educado, respeite todos e principalmente os iniciantes<br> e jogue limpo. A Malta Rp é um RP de respeito e diversão!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 490.webp",
                        alt: "Seja Gente Boa - Regras de comportamento",
                        city: "Malta"
                    },
                    {
                        title: "USO DE ARMAS",
                        description: "⚔️ O uso de armas na Malta Rp é dividida em duas zonas:<br> Norte: uso liberado de todas as armas.<br> Sul: permitido apenas pistolas.<br> ⚠️ Armas pesadas no Sul podem gerar punições.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 491.webp",
                        alt: "Regras de uso de armas",
                        city: "Malta"
                    },
                    {
                        title: "DESCE E QUEBRA",
                        description: "⚔️ Desce e quebra é permitido em áreas remotas, excluindo<br> vias principais da cidade. Permitido desce e quebra apenas em<br> becos, vielas, garagens e interiores.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 492.webp",
                        alt: "Regras de desce e quebra",
                        city: "Malta"
                    },
                    {
                        title: "DICAS",
                        description: "🚗 Quer comprar o seu primeiro veículo?<br> Vá até a Concessionária da Malta Rp e escolha o modelo<br> que mais combina com você.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 493.webp",
                        alt: "Dicas - Comprar veículo",
                        city: "Malta"
                    },
                    {
                        title: "DICAS",
                        description: "💰 Quer lucrar enquanto relaxa?<br> Fique AFK nos farms de pesca ou de leite espalhados pela<br> cidade. Quanto mais tempo ativo, maior o seu ganho!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 494.webp",
                        alt: "Dicas - Farms e ganhos",
                        city: "Malta"
                    },
                    {
                        title: "AJUDA",
                        description: "💡 Teve algum problema ou dúvida?<br> Aperte F5 para abrir um chamado com a equipe da Cidade<br> Malta. Nosso suporte está sempre pronto pra te ajudar!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 495.webp",
                        alt: "Como obter ajuda",
                        city: "Malta"
                    }
                ],
                keyboardConfig: {
                    'esc': 'Use para abrir o Menu principal',
                    'f5': 'Use para abrir um chamado de ajuda',
                    'tab': 'Use para acessar a Hotbar de itens',
                    'caps-lock': 'Segure para falar na rádio conectada.',
                    'r': 'Use para recarregar a sua arma equipada.',
                    't': 'Use para abrir o chat',
                    'p': 'Use para abrir o mapa',
                    'k': 'Use para usar o celular',
                    'home': 'Use para aumentar/dimunuir o volume do microfone',
                    'quote': 'Use para abrir o seu inventário'
                },
                socialLinks: {
                    youtube: '',
                    instagram: 'https://www.instagram.com/maltarp.gg/',
                    discord: 'https://discord.gg/malta-rp',
                    tiktok: 'https://www.tiktok.com/@cidademalta'
                },
                staticTexts: {
                    welcomeText: 'Bem vindo a',
                    socialMediaTitle: 'Redes Sociais',
                    loadingText: 'Estamos carregando todo o seu mapa',
                    ratingTitle: 'CLASSIFICAÇÃO INDICATIVA',
                    ratingReasons: 'Violência, Drogas, Conteúdo sexual',
                    shortcutsDescription: 'Passe o mouse sobre as teclas destacadas para saber mais',
                    shortcutsButtonText: 'Ver Atalhos'
                }
            },
            "Santa": {
                video: `${this.cdnBase}/img/${this.seasonPath}/Santa/SantaLoading.mp4`,
                image: `${this.cdnBase}/img/${this.seasonPath}/Santa/banner_cd.png`,
                audio: `${this.cdnBase}/img/${this.seasonPath}/Santa/santa.mp3`,
                trackArtist: "Cidade Santa",
                slides: [
                    {
                        title: "SEJA GENTE BOA",
                        description: "🤝 Seja educado, respeite todos e principalmente os iniciantes<br> e jogue limpo. A Cidade Santa é um RP de respeito e diversão!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 490.webp",
                        alt: "Seja Gente Boa - Regras de comportamento",
                        city: "Santa"
                    },
                    {
                        title: "USO DE ARMAS",
                        description: "⚔️ O uso de armas na Cidade Santa é dividida em duas zonas:<br> Norte: uso liberado de todas as armas.<br> Sul: permitido apenas pistolas.<br> ⚠️ Armas pesadas no Sul podem gerar punições.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 491.webp",
                        alt: "Regras de uso de armas",
                        city: "Santa"
                    },
                    {
                        title: "DESCE E QUEBRA",
                        description: "⚔️ Desce e quebra é permitido em áreas remotas, excluindo<br> vias principais da cidade. Permitido desce e quebra apenas em<br> becos, vielas, garagens e interiores.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 492.webp",
                        alt: "Regras de desce e quebra",
                        city: "Santa"
                    },
                    {
                        title: "DICAS",
                        description: "🚗 Quer comprar o seu primeiro veículo?<br> Vá até a Concessionária da Cidade Santa e escolha o modelo<br> que mais combina com você.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 493.webp",
                        alt: "Dicas - Comprar veículo",
                        city: "Santa"
                    },
                    {
                        title: "DICAS",
                        description: "💰 Quer lucrar enquanto relaxa?<br> Fique AFK nos farms de pesca ou de leite espalhados pela<br> cidade. Quanto mais tempo ativo, maior o seu ganho!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 494.webp",
                        alt: "Dicas - Farms e ganhos",
                        city: "Santa"
                    },
                    {
                        title: "AJUDA",
                        description: "💡 Teve algum problema ou dúvida?<br> Aperte F5 para abrir um chamado com a equipe da Cidade<br> Santa. Nosso suporte está sempre pronto pra te ajudar!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 495.webp",
                        alt: "Como obter ajuda",
                        city: "Santa"
                    }
                ],
                keyboardConfig: {
                    'esc': 'Use para abrir o Menu principal',
                    'f5': 'Use para abrir um chamado de ajuda',
                    'tab': 'Use para acessar a Hotbar de itens',
                    'caps-lock': 'Segure para falar na rádio conectada.',
                    'r': 'Use para recarregar a sua arma equipada.',
                    't': 'Use para abrir o chat',
                    'p': 'Use para abrir o mapa',
                    'k': 'Use para usar o celular',
                    'home': 'Use para aumentar/dimunuir o volume do microfone',
                    'quote': 'Use para abrir o seu inventário'
                },
                socialLinks: {
                    youtube: 'https://www.youtube.com/@CidadeSantaRP',
                    instagram: 'https://www.instagram.com/cidadesanta.gg/',
                    discord: 'https://discord.gg/cidadesanta',
                    tiktok: 'https://www.tiktok.com/@cidadesanta.gg'
                },
                staticTexts: {
                    welcomeText: 'Bem vindo a',
                    socialMediaTitle: 'Redes Sociais',
                    loadingText: 'Estamos carregando todo o seu mapa',
                    ratingTitle: 'CLASSIFICAÇÃO INDICATIVA',
                    ratingReasons: 'Violência, Drogas, Conteúdo sexual',
                    shortcutsDescription: 'Passe o mouse sobre as teclas destacadas para saber mais',
                    shortcutsButtonText: 'Ver Atalhos'
                }
            },
            "GoatRP": {
                video: `${this.cdnBase}/img/${this.seasonPath}/GoatRP/GoatRP.mp4`,
                image: `${this.cdnBase}/img/${this.seasonPath}/GoatRP/banner_cd.png`,
                audio: `${this.cdnBase}/img/${this.seasonPath}/GoatRP/GoatRP.mp3`,
                trackArtist: "Goat RP",
                slides: [
                    {
                        title: "SOYEZ BIENVEILLANT",
                        description: "🤝 Soyez poli, respectez tout le monde, surtout les débutants<br> et jouez fair-play. La Goat RP est un RP de respect et de divertissement !",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp490.png",
                        alt: "Soyez bienveillant - Règles de comportement",
                        city: "GoatRP"
                    },
                    {
                        title: "UTILISATION DES ARMES",
                        description: "⚔️ L'utilisation des armes à Cidade Santa est divisée en deux zones :<br> Nord : utilisation libre de toutes les armes.<br> Sud : seules les armes de poing sont autorisées.<br> ⚠️ Les armes lourdes dans le Sud peuvent entraîner des sanctions.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 491.webp",
                        alt: "Règles d'utilisation des armes",
                        city: "GoatRP"
                    },
                    {
                        title: "DESCENDRE ET CASSER",
                        description: "⚔️ Le « descendre et casser » est autorisé dans les zones éloignées, à l'exclusion<br> des voies principales de la ville. Autorisé uniquement dans les<br> ruelles, passages, garages et intérieurs.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp492.png",
                        alt: "Règles de descendre et casser",
                        city: "GoatRP"
                    },
                    {
                        title: "CONSEILS",
                        description: "🚗 Vous voulez acheter votre premier véhicule ?<br> Rendez-vous au concessionnaire de Goat RP et choisissez le modèle<br> qui vous correspond le mieux.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 493.webp",
                        alt: "Conseils - Acheter un véhicule",
                        city: "GoatRP"
                    },
                    {
                        title: "CONSEILS",
                        description: "💰 Vous voulez gagner de l'argent en vous relaxant ?<br> Restez AFK dans les farms de pêche ou de lait répartis dans la<br> ville. Plus vous restez actif, plus vos gains augmentent !",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 494.webp",
                        alt: "Conseils - Farms et gains",
                        city: "GoatRP"
                    },
                    {
                        title: "AIDE",
                        description: "💡 Vous avez eu un problème ou un doute ?<br> Appuyez sur F5 pour ouvrir un ticket avec l'équipe de Goat RP. Notre support est toujours prêt à vous aider !",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 495.webp",
                        alt: "Comment obtenir de l'aide",
                        city: "GoatRP"
                    }
                ],
                keyboardConfig: {
                    'esc': 'Utilisez pour ouvrir le menu principal',
                    'f5': 'Utilisez pour ouvrir un ticket d\'aide',
                    'tab': 'Utilisez pour accéder à la hotbar des objets',
                    'caps-lock': 'Maintenez pour parler sur la radio connectée.',
                    'r': 'Utilisez pour recharger votre arme équipée.',
                    't': 'Utilisez pour ouvrir le chat',
                    'p': 'Utilisez pour ouvrir la carte',
                    'k': 'Utilisez pour utiliser le téléphone',
                    'home': 'Utilisez pour augmenter/réduire le volume du microphone',
                    'quote': 'Utilisez pour ouvrir votre inventaire'
                },
                socialLinks: {
                    youtube: 'https://www.youtube.com/@',
                    instagram: 'https://www.instagram.com/',
                    discord: 'https://discord.gg/goatrp',
                    tiktok: 'https://www.tiktok.com/@'
                },
                staticTexts: {
                    welcomeText: 'Bienvenue à',
                    socialMediaTitle: 'Réseaux sociaux',
                    loadingText: 'Nous chargeons toute votre carte',
                    ratingTitle: 'CLASSIFICATION D\'ÂGE',
                    ratingReasons: 'Violence, Drogues, Contenu sexuel',
                    shortcutsDescription: 'Passez la souris sur les touches en surbrillance pour en savoir plus',
                    shortcutsButtonText: 'Voir les raccourcis'
                }
            },
            "Alexandria": {
                video: `${this.cdnBase}/img/${this.seasonPath}/Alexandria/loading.mp4`,
                image: `${this.cdnBase}/img/${this.seasonPath}/Alexandria/banner_cd.png`,
                audio: `${this.cdnBase}/img/${this.seasonPath}/Alexandria/song.mp3`,
                trackArtist: "Alexandria",
                slides: [
                    {
                        title: "SEJA GENTE BOA",
                        description: "🤝 Seja educado, respeite todos e principalmente os iniciantes<br> e jogue limpo. A Cidade Alexandria é um RP de respeito e diversão!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 490.webp",
                        alt: "Seja Gente Boa - Regras de comportamento",
                        city: "Alexandria"
                    },
                    {
                        title: "USO DE ARMAS",
                        description: "⚔️ O uso de armas na Cidade Alexandria é dividida em duas zonas:<br> Norte: uso liberado de todas as armas.<br> Sul: permitido apenas pistolas.<br> ⚠️ Armas pesadas no Sul podem gerar punições.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 491.webp",
                        alt: "Regras de uso de armas",
                        city: "Alexandria"
                    },
                    {
                        title: "DESCE E QUEBRA",
                        description: "⚔️ Desce e quebra é permitido em áreas remotas, excluindo<br> vias principais da cidade. Permitido desce e quebra apenas em<br> becos, vielas, garagens e interiores.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 492.webp",
                        alt: "Regras de desce e quebra",
                        city: "Alexandria"
                    },
                    {
                        title: "DICAS",
                        description: "🚗 Quer comprar o seu primeiro veículo?<br> Vá até a Concessionária da Cidade Alexandria e escolha o modelo<br> que mais combina com você.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 493.webp",
                        alt: "Dicas - Comprar veículo",
                        city: "Alexandria"
                    },
                    {
                        title: "DICAS",
                        description: "💰 Quer lucrar enquanto relaxa?<br> Fique AFK nos farms de pesca ou de leite espalhados pela<br> cidade. Quanto mais tempo ativo, maior o seu ganho!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 494.webp",
                        alt: "Dicas - Farms e ganhos",
                        city: "Alexandria"
                    },
                    {
                        title: "AJUDA",
                        description: "💡 Teve algum problema ou dúvida?<br> Aperte F5 para abrir um chamado com a equipe da Cidade<br> Alexandria. Nosso suporte está sempre pronto pra te ajudar!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 495.webp",
                        alt: "Como obter ajuda",
                        city: "Alexandria"
                    }
                ],
                keyboardConfig: {
                    'esc': 'Use para abrir o Menu principal',
                    'f5': 'Use para abrir um chamado de ajuda',
                    'tab': 'Use para acessar a Hotbar de itens',
                    'caps-lock': 'Segure para falar na rádio conectada.',
                    'r': 'Use para recarregar a sua arma equipada.',
                    't': 'Use para abrir o chat',
                    'p': 'Use para abrir o mapa',
                    'k': 'Use para usar o celular',
                    'home': 'Use para aumentar/dimunuir o volume do microfone',
                    'quote': 'Use para abrir o seu inventário'
                },
                socialLinks: {
                    youtube: '',
                    instagram: '',
                    discord: 'https://discord.gg/alexandria-rp',
                    tiktok: ''
                },
                staticTexts: {
                    welcomeText: 'Bem vindo a',
                    socialMediaTitle: 'Redes Sociais',
                    loadingText: 'Estamos carregando todo o seu mapa',
                    ratingTitle: 'CLASSIFICAÇÃO INDICATIVA',
                    ratingReasons: 'Violência, Drogas, Conteúdo sexual',
                    shortcutsDescription: 'Passe o mouse sobre as teclas destacadas para saber mais',
                    shortcutsButtonText: 'Ver Atalhos'
                }
            },
            "Kingdom": {
                video: `${this.cdnBase}/img/${this.seasonPath}/Kingdom/kngloading2.mp4`,
                image: `${this.cdnBase}/img/${this.seasonPath}/Kingdom/banner_cd.png`,
                audio: `${this.cdnBase}/img/${this.seasonPath}/Kingdom/kngmusic2.mp3`,
                trackArtist: "Kingdom Estate",
                slides: [
                    {
                        title: "BE NICE",
                        description: "Be polite, respect everyone and especially beginners,<br> and play fair. Kingdom City is an RP of respect and fun!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp490.png",
                        alt: "Be Nice - Behavior rules",
                        city: "Kingdom"
                    },
                    {
                        title: "WEAPON USAGE",
                        description: "Weapon usage in Kingdom City is divided into two zones:<br> North: all weapons allowed.<br> South: only pistols permitted.<br> ⚠️ Heavy weapons in the South may result in punishments.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 491.webp",
                        alt: "Weapon usage rules",
                        city: "Kingdom"
                    },
                    {
                        title: "DROP AND BREAK",
                        description: "Drop and break is allowed in remote areas, excluding<br> main city streets. Drop and break is only permitted in<br> alleys, side streets, garages, and interiors.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp492.png",
                        alt: "Drop and break rules",
                        city: "Kingdom"
                    },
                    {
                        title: "TIPS",
                        description: "🚗 Want to buy your first vehicle?<br> Go to the Kingdom City Dealership and choose the model<br> that best suits you.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 493.webp",
                        alt: "Tips - Buy vehicle",
                        city: "Kingdom"
                    },
                    {
                        title: "TIPS",
                        description: "💰 Want to earn while relaxing?<br> Stay AFK at fishing or milk farms scattered around the<br> city. The more time active, the greater your earnings!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 494.webp",
                        alt: "Tips - Farms and earnings",
                        city: "Kingdom"
                    },
                    {
                        title: "HELP",
                        description: "💡 Had a problem or question?<br> Press F5 to open a ticket with the <br>Kingdom City team. Our support is always ready to help you!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 495.webp",
                        alt: "How to get help",
                        city: "Kingdom"
                    }
                ],
                keyboardConfig: {
                    'esc': 'Use to open the Main menu',
                    'f5': 'Use to open a help ticket',
                    'tab': 'Use to access the Items hotbar',
                    'caps-lock': 'Hold to speak on the connected radio.',
                    'r': 'Use to reload your equipped weapon.',
                    't': 'Use to open the chat',
                    'p': 'Use to open the map',
                    'k': 'Use to use the phone',
                    'home': 'Use to increase/decrease microphone volume',
                    'quote': 'Use to open your inventory'
                },
                socialLinks: {
                    youtube: '',
                    instagram: 'https://www.instagram.com/kngcity.gg',
                    discord: 'https://discord.gg/kngestate',
                    tiktok: 'https://www.tiktok.com/@kngcity.gg'
                },
                staticTexts: {
                    welcomeText: 'Welcome to',
                    socialMediaTitle: 'Social Media',
                    loadingText: 'We are loading your entire map',
                    ratingTitle: 'CONTENT RATING',
                    ratingReasons: 'Violence, Drugs, Sexual content',
                    shortcutsDescription: 'View shortcuts hover over the highlighted keys',
                    shortcutsButtonText: 'View Shortcuts'
                }
            },
            "District99": {
                video: `${this.cdnBase}/img/${this.seasonPath}/District99/District99loading.mp4`,
                image: `${this.cdnBase}/img/${this.seasonPath}/District99/banner_cd.png`,
                audio: `${this.cdnBase}/img/${this.seasonPath}/District99/District99.mp3`,
                trackArtist: "District99",
                slides: [
                    {
                        title: "BE NICE",
                        description: "Be polite, respect everyone and especially beginners,<br> and play fair. District99 is an RP of respect and fun!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp490.png",
                        alt: "Be Nice - Behavior rules",
                        city: "District99"
                    },
                    {
                        title: "WEAPON USAGE",
                        description: "Weapon usage in District99 is divided into two zones:<br> North: all weapons allowed.<br> South: only pistols permitted.<br> ⚠️ Heavy weapons in the South may result in punishments.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 491.webp",
                        alt: "Weapon usage rules",
                        city: "District99"
                    },
                    {
                        title: "DROP AND BREAK",
                        description: "Drop and break is allowed in remote areas, excluding<br> main city streets. Drop and break is only permitted in<br> alleys, side streets, garages, and interiors.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp492.png",
                        alt: "Drop and break rules",
                        city: "District99"
                    },
                    {
                        title: "TIPS",
                        description: "🚗 Want to buy your first vehicle?<br> Go to the District99 Dealership and choose the model<br> that best suits you.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 493.webp",
                        alt: "Tips - Buy vehicle",
                        city: "District99"
                    },
                    {
                        title: "TIPS",
                        description: "💰 Want to earn while relaxing?<br> Stay AFK at fishing or milk farms scattered around the<br> city. The more time active, the greater your earnings!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 494.webp",
                        alt: "Tips - Farms and earnings",
                        city: "District99"
                    },
                    {
                        title: "HELP",
                        description: "💡 Had a problem or question?<br> Press F5 to open a ticket with the <br>District99 team. Our support is always ready to help you!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 495.webp",
                        alt: "How to get help",
                        city: "District99"
                    }
                ],
                keyboardConfig: {
                    'esc': 'Use to open the Main menu',
                    'f5': 'Use to open a help ticket',
                    'tab': 'Use to access the Items hotbar',
                    'caps-lock': 'Hold to speak on the connected radio.',
                    'r': 'Use to reload your equipped weapon.',
                    't': 'Use to open the chat',
                    'p': 'Use to open the map',
                    'k': 'Use to use the phone',
                    'home': 'Use to increase/decrease microphone volume',
                    'quote': 'Use to open your inventory'
                },
                socialLinks: {
                    youtube: '',
                    instagram: 'https://www.instagram.com/district99.gg',
                    discord: 'https://discord.gg/d-99',
                    tiktok: 'https://www.tiktok.com/@districtrp.gg'
                },
                staticTexts: {
                    welcomeText: 'Welcome to',
                    socialMediaTitle: 'Social Media',
                    loadingText: 'We are loading your entire map',
                    ratingTitle: 'CONTENT RATING',
                    ratingReasons: 'Violence, Drugs, Sexual content',
                    shortcutsDescription: 'View shortcuts hover over the highlighted keys',
                    shortcutsButtonText: 'View Shortcuts'
                }
            },

            "Krown": {
                video: `${this.cdnBase}/img/${this.seasonPath}/Krown/Krownloading.mp4`,
                image: `${this.cdnBase}/img/${this.seasonPath}/Krown/banner_cd.png`,
                audio: `${this.cdnBase}/img/${this.seasonPath}/Krown/Krown.mp3`,
                trackArtist: "Krown",
                slides: [
                    {
                        title: "BE NICE",
                        description: "Be polite, respect everyone and especially beginners,<br> and play fair. Krown is an RP of respect and fun!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp490.png",
                        alt: "Be Nice - Behavior rules",
                        city: "Krown"
                    },
                    {
                        title: "WEAPON USAGE",
                        description: "Weapon usage in Krown is divided into two zones:<br> North: all weapons allowed.<br> South: only pistols permitted.<br> ⚠️ Heavy weapons in the South may result in punishments.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 491.webp",
                        alt: "Weapon usage rules",
                        city: "Krown"
                    },
                    {
                        title: "DROP AND BREAK",
                        description: "Drop and break is allowed in remote areas, excluding<br> main city streets. Drop and break is only permitted in<br> alleys, side streets, garages, and interiors.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp492.png",
                        alt: "Drop and break rules",
                        city: "Krown"
                    },
                    {
                        title: "TIPS",
                        description: "🚗 Want to buy your first vehicle?<br> Go to the Krown Dealership and choose the model<br> that best suits you.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 493.webp",
                        alt: "Tips - Buy vehicle",
                        city: "Krown"
                    },
                    {
                        title: "TIPS",
                        description: "💰 Want to earn while relaxing?<br> Stay AFK at fishing or milk farms scattered around the<br> city. The more time active, the greater your earnings!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 494.webp",
                        alt: "Tips - Farms and earnings",
                        city: "Krown"
                    },
                    {
                        title: "HELP",
                        description: "💡 Had a problem or question?<br> Press F5 to open a ticket with the <br>Krown team. Our support is always ready to help you!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 495.webp",
                        alt: "How to get help",
                        city: "Krown"
                    }
                ],
                keyboardConfig: {
                    'esc': 'Use to open the Main menu',
                    'f5': 'Use to open a help ticket',
                    'tab': 'Use to access the Items hotbar',
                    'caps-lock': 'Hold to speak on the connected radio.',
                    'r': 'Use to reload your equipped weapon.',
                    't': 'Use to open the chat',
                    'p': 'Use to open the map',
                    'k': 'Use to use the phone',
                    'home': 'Use to increase/decrease microphone volume',
                    'quote': 'Use to open your inventory'
                },
                socialLinks: {
                    youtube: '',
                    instagram: '',
                    discord: 'https://discord.gg/krownrp',
                    tiktok: ''
                },
                staticTexts: {
                    welcomeText: 'Welcome to',
                    socialMediaTitle: 'Social Media',
                    loadingText: 'We are loading your entire map',
                    ratingTitle: 'CONTENT RATING',
                    ratingReasons: 'Violence, Drugs, Sexual content',
                    shortcutsDescription: 'View shortcuts hover over the highlighted keys',
                    shortcutsButtonText: 'View Shortcuts'
                }
            },

          "Orizon": {
                video: `${this.cdnBase}/img/${this.seasonPath}/Orizon/Orizon.mp4`,
                image: `${this.cdnBase}/img/${this.seasonPath}/Orizon/banner_cd.png`,
                audio: `${this.cdnBase}/img/${this.seasonPath}/Orizon/Orizon.mp3`,
                trackArtist: "Orizon",
                slides: [
                    {
                        title: "كن لطيفًا",
                        description: "🤝 كن لطيفًا ومهذبًا، واحترم الجميع خصوصًا المبتدئين.<br> استمتع بلعب الأدوار في أورايزن بروح الاحترام والمتعة،<br> والعب دائمًا بنزاهة داخل المدينة.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp490.png",
                        alt: "كن لطيفًا - قواعد السلوك",
                        city: "Orizon"
                    },
                    {
                        title: "استخدام الأسلحة",
                        description: "⚔️ تنقسم منطقة اورايزن إلى منطقتين فيما يخص استخدام الأسلحة:<br>• الشمال: يُسمح باستخدام جميع أنواع الأسلحة.<br>• الجنوب: يُسمح فقط باستخدام المسدسات.<br>• ⚠️ الأسلحة الثقيلة في الجنوب: يُمنع استخدامها.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 491.webp",
                        alt: "قواعد استخدام الأسلحة",
                        city: "Orizon"
                    }, 
                    {
                        title: "القتال",
                        description: "⚔️ يُسمح بالقتال في المناطق النائية فقط، مع منع تام في الشوارع الرئيسية للمدينة.<br> ويُسمح به حصراً في الأزقة، والمرائب، والمنازل.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp492.png",
                        alt: "قواعد القتال",
                        city: "Orizon"
                    },
                    {
                        title: "نصائح",
                        description: "🚗 هل تريد شراء سيارتك الأولى؟<br> اذهب إلى وكالة السيارات في مدينة أورايزن،<br> واختر الموديل الذي يناسبك أكثر.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 493.webp",
                        alt: "نصائح - شراء السيارة",
                        city: "Orizon"
                    },
                    {
                        title: "نصائح",
                        description: "💰 هل ترغب في تحقيق الأرباح أثناء الاسترخاء؟<br> يمكنك البقاء في وضع الخمول داخل مزارع الصيد أو مزارع الحليب المنتشرة في المدينة.<br> كلما زاد وقت نشاطك، زادت أرباحك.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 494.webp",
                        alt: "نصائح - المزارع والأرباح",
                        city: "Orizon"
                    },
                    {
                        title: "مساعدة",
                        description: "💡 هل تواجه مشكلة أو لديك استفسار؟<br> لفتح طلب دعم مع فريق مدينة أورايزن، اضغط على زر F5.<br> نحن هنا دائمًا لمساعدتك.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 495.webp",
                        alt: "كيفية الحصول على المساعدة",
                        city: "Orizon"
                    }
                ],
                keyboardConfig: {
                    'esc':       'استخدم لفتح القائمة الرئيسية',
                    'f5':        'استخدم لفتح طلب المساعدة',
                    'tab':       'استخدم للوصول إلى شريط العناصر',
                    'caps-lock': 'اضغط مع الاستمرار للتحدث على الراديو المتصل.',
                    'r':         'استخدم لإعادة تعبئة السلاح المجهز.',
                    't':         'استخدم لفتح الدردشة',
                    'p':         'استخدم لفتح الخريطة',
                    'k':         'استخدم للوصول إلى الهاتف',
                    'home':      'استخدم لرفع/خفض صوت الميكروفون',
                    'quote':     'استخدم لفتح حقيبتك'
                },
                socialLinks: {
                    youtube: '',
                    instagram: '',
                    discord: 'https://discord.gg/taaGvEtbMv',
                    tiktok: ''
                },
                staticTexts: {
                    welcomeText:          'مرحبا بك في',
                    socialMediaTitle:     'وسائل التواصل الاجتماعي',
                    loadingText:          'جاري تحميل الخريطة بالكامل',
                    ratingTitle:          'تصنيف المحتوى',
                    ratingReasons:        'عنف، مخدرات، محتوى جنسي',
                    shortcutsDescription: 'مرر الماوس فوق المفاتيح المميزة لمعرفة المزيد',
                    shortcutsButtonText:  'عرض الاختصارات'
                }
            },
            "Liberty99": {
                video: `https://cdn.santagroup.gg/loadscreen/be31d3da-708e-446f-9968-42b4bec6f9d6-loadscreen_video_liberty99.webm`,
                image: `${this.legacyCdnBase}/img/${this.seasonPath}/Liberty99/banner_cd.png`,
                audio: `${this.cdnBase}/img/${this.seasonPath}/Liberty99/Liberty99.mp3`,
                trackArtist: "Liberty99",
                slides: [
                    {
                        title: "BE NICE",
                        description: "Be polite, respect everyone and especially beginners,<br> and play fair. Liberty99 is an RP of respect and fun!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp490.png",
                        alt: "Be Nice - Behavior rules",
                        city: "Liberty99"
                    },
                    {
                        title: "WEAPON USAGE",
                        description: "Weapon usage in Liberty99 is divided into two zones:<br> North: all weapons allowed.<br> South: only pistols permitted.<br> ⚠️ Heavy weapons in the South may result in punishments.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 491.webp",
                        alt: "Weapon usage rules",
                        city: "Liberty99"
                    },
                    {
                        title: "DROP AND BREAK",
                        description: "Drop and break is allowed in remote areas, excluding<br> main city streets. Drop and break is only permitted in<br> alleys, side streets, garages, and interiors.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp492.png",
                        alt: "Drop and break rules",
                        city: "Liberty99"
                    },
                    {
                        title: "TIPS",
                        description: "🚗 Want to buy your first vehicle?<br> Go to the Liberty99 Dealership and choose the model<br> that best suits you.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 493.webp",
                        alt: "Tips - Buy vehicle",
                        city: "Liberty99"
                    },
                    {
                        title: "TIPS",
                        description: "💰 Want to earn while relaxing?<br> Stay AFK at fishing or milk farms scattered around the<br> city. The more time active, the greater your earnings!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 494.webp",
                        alt: "Tips - Farms and earnings",
                        city: "Liberty99"
                    },
                    {
                        title: "HELP",
                        description: "💡 Had a problem or question?<br> Press F5 to open a ticket with the <br>Liberty99 team. Our support is always ready to help you!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 495.webp",
                        alt: "How to get help",
                        city: "Liberty99"
                    }
                ],
                keyboardConfig: {
                    'esc': 'Use to open the Main menu',
                    'f5': 'Use to open a help ticket',
                    'tab': 'Use to access the Items hotbar',
                    'caps-lock': 'Hold to speak on the connected radio.',
                    'r': 'Use to reload your equipped weapon.',
                    't': 'Use to open the chat',
                    'p': 'Use to open the map',
                    'k': 'Use to use the phone',
                    'home': 'Use to increase/decrease microphone volume',
                    'quote': 'Use to open your inventory'
                },
                socialLinks: {
                    youtube: '',
                    instagram: 'https://www.instagram.com/liberty99.gg',
                    discord: 'https://discord.gg/l99',
                    tiktok: 'https://www.instagram.com/liberty99.gg'
                },
                staticTexts: {
                    welcomeText: 'Welcome to',
                    socialMediaTitle: 'Social Media',
                    loadingText: 'We are loading your entire map',
                    ratingTitle: 'CONTENT RATING',
                    ratingReasons: 'Violence, Drugs, Sexual content',
                    shortcutsDescription: 'View shortcuts hover over the highlighted keys',
                    shortcutsButtonText: 'View Shortcuts'
                }
            },
            "Maresia": {
                video: `${this.cdnBase}/img/${this.seasonPath}/Maresia/maresia.mp4`,
                image: `${this.cdnBase}/img/${this.seasonPath}/Maresia/banner_cd.png`,
                audio: `${this.cdnBase}/img/${this.seasonPath}/Maresia/maresia.mp3`,
                trackArtist: "Cidade Maresia",
                slides: [
                    {
                        title: "SEJA GENTE BOA",
                        description: "🤝 Seja educado, respeite todos e principalmente os iniciantes<br> e jogue limpo. A Cidade Maresia é um RP de respeito e diversão!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 490.webp",
                        alt: "Seja Gente Boa - Regras de comportamento",
                        city: "Maresia"
                    },
                    {
                        title: "USO DE ARMAS",
                        description: "⚔️ O uso de armas na Cidade Maresia é dividida em duas zonas:<br> Norte: uso liberado de todas as armas.<br> Sul: permitido apenas pistolas.<br> ⚠️ Armas pesadas no Sul podem gerar punições.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 491.webp",
                        alt: "Regras de uso de armas",
                        city: "Maresia"
                    },
                    {
                        title: "DESCE E QUEBRA",
                        description: "⚔️ Desce e quebra é permitido em áreas remotas, excluindo<br> vias principais da cidade. Permitido desce e quebra apenas em<br> becos, vielas, garagens e interiores.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 492.webp",
                        alt: "Regras de desce e quebra",
                        city: "Maresia"
                    },
                    {
                        title: "DICAS",
                        description: "🚗 Quer comprar o seu primeiro veículo?<br> Vá até a Concessionária da Cidade Maresia e escolha o modelo<br> que mais combina com você.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 493.webp",
                        alt: "Dicas - Comprar veículo",
                        city: "Maresia"
                    },
                    {
                        title: "DICAS",
                        description: "💰 Quer lucrar enquanto relaxa?<br> Fique AFK nos farms de pesca ou de leite espalhados pela<br> cidade. Quanto mais tempo ativo, maior o seu ganho!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 494.webp",
                        alt: "Dicas - Farms e ganhos",
                        city: "Maresia"
                    },
                    {
                        title: "AJUDA",
                        description: "💡 Teve algum problema ou dúvida?<br> Aperte F5 para abrir um chamado com a equipe da Cidade<br> Maresia. Nosso suporte está sempre pronto pra te ajudar!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 495.webp",
                        alt: "Como obter ajuda",
                        city: "Maresia"
                    }
                ],
                keyboardConfig: {
                    'esc': 'Use para abrir o Menu principal',
                    'f5': 'Use para abrir um chamado de ajuda',
                    'tab': 'Use para acessar a Hotbar de itens',
                    'caps-lock': 'Segure para falar na rádio conectada.',
                    'r': 'Use para recarregar a sua arma equipada.',
                    't': 'Use para abrir o chat',
                    'p': 'Use para abrir o mapa',
                    'k': 'Use para usar o celular',
                    'home': 'Use para aumentar/dimunuir o volume do microfone',
                    'quote': 'Use para abrir o seu inventário'
                },
                socialLinks: {
                    youtube: '',
                    instagram: 'https://www.instagram.com/cidademaresia.gg/',
                    discord: 'https://discord.gg/cidademaresia',
                    tiktok: 'https://www.tiktok.com/@cidademaresiarp'
                },
                staticTexts: {
                    welcomeText: 'Bem vindo a',
                    socialMediaTitle: 'Redes Sociais',
                    loadingText: 'Estamos carregando todo o seu mapa',
                    ratingTitle: 'CLASSIFICAÇÃO INDICATIVA',
                    ratingReasons: 'Violência, Drogas, Conteúdo sexual',
                    shortcutsDescription: 'Passe o mouse sobre as teclas destacadas para saber mais',
                    shortcutsButtonText: 'Ver Atalhos'
                }
            },
            "Fronteira": {
                video: `${this.cdnBase}/img/${this.seasonPath}/Fronteira/fronteira.mp4`,
                image: `${this.cdnBase}/img/${this.seasonPath}/Fronteira/banner_cd.png`,
                audio: `${this.cdnBase}/img/${this.seasonPath}/Fronteira/fronteira.mp3`,
                trackArtist: "Fronteira RP",
                slides: [
                    {
                        title: "SEJA GENTE BOA",
                        description: "🤝 Seja educado, respeite todos e principalmente os iniciantes<br> e jogue limpo. A Cidade Fronteira é um RP de respeito e diversão!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 490.webp",
                        alt: "Seja Gente Boa - Regras de comportamento",
                        city: "Fronteira"
                    },
                    {
                        title: "USO DE ARMAS",
                        description: "⚔️ O uso de armas na Cidade Fronteira é dividida em duas zonas:<br> Norte: uso liberado de todas as armas.<br> Sul: permitido apenas pistolas.<br> ⚠️ Armas pesadas no Sul podem gerar punições.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 491.webp",
                        alt: "Regras de uso de armas",
                        city: "Fronteira"
                    },
                    {
                        title: "DESCE E QUEBRA",
                        description: "⚔️ Desce e quebra é permitido em áreas remotas, excluindo<br> vias principais da cidade. Permitido desce e quebra apenas em<br> becos, vielas, garagens e interiores.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 492.webp",
                        alt: "Regras de desce e quebra",
                        city: "Fronteira"
                    },
                    {
                        title: "DICAS",
                        description: "🚗 Quer comprar o seu primeiro veículo?<br> Vá até a Concessionária da Cidade Fronteira e escolha o modelo<br> que mais combina com você.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 493.webp",
                        alt: "Dicas - Comprar veículo",
                        city: "Fronteira"
                    },
                    {
                        title: "DICAS",
                        description: "💰 Quer lucrar enquanto relaxa?<br> Fique AFK nos farms de pesca ou de leite espalhados pela<br> cidade. Quanto mais tempo ativo, maior o seu ganho!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 494.webp",
                        alt: "Dicas - Farms e ganhos",
                        city: "Fronteira"
                    },
                    {
                        title: "AJUDA",
                        description: "💡 Teve algum problema ou dúvida?<br> Aperte F5 para abrir um chamado com a equipe da Cidade<br> Fronteira. Nosso suporte está sempre pronto pra te ajudar!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 495.webp",
                        alt: "Como obter ajuda",
                        city: "Fronteira"
                    }
                ],
                keyboardConfig: {
                    'esc': 'Use para abrir o Menu principal',
                    'f5': 'Use para abrir um chamado de ajuda',
                    'tab': 'Use para acessar a Hotbar de itens',
                    'caps-lock': 'Segure para falar na rádio conectada.',
                    'r': 'Use para recarregar a sua arma equipada.',
                    't': 'Use para abrir o chat',
                    'p': 'Use para abrir o mapa',
                    'k': 'Use para usar o celular',
                    'home': 'Use para aumentar/dimunuir o volume do microfone',
                    'quote': 'Use para abrir o seu inventário'
                },
                socialLinks: {
                    youtube: '',
                    instagram: '',
                    discord: 'https://discord.gg/fronteira',
                    tiktok: ''
                },
                staticTexts: {
                    welcomeText: 'Bem vindo a',
                    socialMediaTitle: 'Redes Sociais',
                    loadingText: 'Estamos carregando todo o seu mapa',
                    ratingTitle: 'CLASSIFICAÇÃO INDICATIVA',
                    ratingReasons: 'Violência, Drogas, Conteúdo sexual',
                    shortcutsDescription: 'Passe o mouse sobre as teclas destacadas para saber mais',
                    shortcutsButtonText: 'Ver Atalhos'
                }
            },
            "CidadeNobre": {
                video: `${this.cdnBase}/img/${this.seasonPath}/CidadeNobre/CidadeNobre.mp4`,
                image: `${this.cdnBase}/img/${this.seasonPath}/CidadeNobre/banner_cd.png`,
                audio: `${this.cdnBase}/img/${this.seasonPath}/CidadeNobre/nobre23.mp3`,
                trackArtist: "Cidade Nobre",
                slides: [
                    {
                        title: "SEJA GENTE BOA",
                        description: "🤝 Seja educado, respeite todos e principalmente os iniciantes<br> e jogue limpo. A Cidade Nobre é um RP de respeito e diversão!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 490.webp",
                        alt: "Seja Gente Boa - Regras de comportamento",
                        city: "CidadeNobre"
                    },
                    {
                        title: "USO DE ARMAS",
                        description: "⚔️ O uso de armas na Cidade Nobre é dividida em duas zonas:<br> Norte: uso liberado de todas as armas.<br> Sul: permitido apenas pistolas.<br> ⚠️ Armas pesadas no Sul podem gerar punições.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 491.webp",
                        alt: "Regras de uso de armas",
                        city: "CidadeNobre"
                    },
                    {
                        title: "DESCE E QUEBRA",
                        description: "⚔️ Desce e quebra é permitido em áreas remotas, excluindo<br> vias principais da cidade. Permitido desce e quebra apenas em<br> becos, vielas, garagens e interiores.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 492.webp",
                        alt: "Regras de desce e quebra",
                        city: "CidadeNobre"
                    },
                    {
                        title: "DICAS",
                        description: "🚗 Quer comprar o seu primeiro veículo?<br> Vá até a Concessionária da Cidade Nobre e escolha o modelo<br> que mais combina com você.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 493.webp",
                        alt: "Dicas - Comprar veículo",
                        city: "CidadeNobre"
                    },
                    {
                        title: "DICAS",
                        description: "💰 Quer lucrar enquanto relaxa?<br> Fique AFK nos farms de pesca ou de leite espalhados pela<br> cidade. Quanto mais tempo ativo, maior o seu ganho!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 494.webp",
                        alt: "Dicas - Farms e ganhos",
                        city: "CidadeNobre"
                    },
                    {
                        title: "AJUDA",
                        description: "💡 Teve algum problema ou dúvida?<br> Aperte F5 para abrir um chamado com a equipe da Cidade<br> Nobre. Nosso suporte está sempre pronto pra te ajudar!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 495.webp",
                        alt: "Como obter ajuda",
                        city: "CidadeNobre"
                    }
                ],
                keyboardConfig: {
                    'esc': 'Use para abrir o Menu principal',
                    'f5': 'Use para abrir um chamado de ajuda',
                    'tab': 'Use para acessar a Hotbar de itens',
                    'caps-lock': 'Segure para falar na rádio conectada.',
                    'r': 'Use para recarregar a sua arma equipada.',
                    't': 'Use para abrir o chat',
                    'p': 'Use para abrir o mapa',
                    'k': 'Use para usar o celular',
                    'home': 'Use para aumentar/dimunuir o volume do microfone',
                    'quote': 'Use para abrir o seu inventário'
                },
                socialLinks: {
                    youtube: 'https://www.youtube.com/@cidadenobrerp',
                    instagram: 'https://www.instagram.com/cidadenobre.gg',
                    discord: 'https://discord.gg/cidadenobre',
                    tiktok: 'https://www.tiktok.com/@cidadenobre'
                },
                staticTexts: {
                    welcomeText: 'Bem-vindo à',
                    socialMediaTitle: 'Nossas Redes',
                    loadingText: 'Estamos carregando todo o seu mapa da Cidade Nobre',
                    ratingTitle: 'CLASSIFICAÇÃO INDICATIVA',
                    ratingReasons: 'Violência, Drogas, Conteúdo sexual',
                    shortcutsDescription: 'Passe o mouse sobre as teclas destacadas para saber mais',
                    shortcutsButtonText: 'Ver Atalhos'
                }
            },
            "Real": {
                video: `${this.cdnBase}/img/${this.legacyPath}/Real/loading.mp4`,
                image: `${this.cdnBase}/img/${this.legacyPath}/Real/banner_cd.png`,
                audio: `${this.cdnBase}/img/${this.legacyPath}/Real/song.mp3`,
                trackArtist: "Ciudad Real",
                slides: [
                    {
                        title: "SE BUENO",
                        description: "Sé educado, respeta a todos y especialmente a los principiantes<br> y juega limpio. Ciudad Real es un RP de respeto y diversión!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp490.png",
                        alt: "Sé Bueno - Reglas de comportamiento",
                        city: "Real"
                    },
                    {
                        title: "USO DE ARMAS",
                        description: "El uso de armas en Ciudad Real está dividido en dos zonas:<br> Norte: uso libre de todas las armas.<br> Sur: solo pistolas permitidas.<br> ⚠️ Armas pesadas en el Sur pueden generar sanciones.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 491.webp",
                        alt: "Reglas de uso de armas",
                        city: "Real"
                    },
                    {
                        title: "BAJA Y ROMPE",
                        description: "Baja y rompe está permitido en áreas remotas, excluyendo<br> vías principales de la ciudad. Permitido bajar y romper solo en<br> callejones, callejuelas, garajes e interiores.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp492.png",
                        alt: "Reglas de baja y rompe",
                        city: "Real"
                    },
                    {
                        title: "CONSEJOS",
                        description: "🚗 ¿Quieres comprar tu primer vehículo?<br> Ve a la Concesionaria de Ciudad Real y elige el modelo<br> que más te guste.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 493.webp",
                        alt: "Consejos - Comprar vehículo",
                        city: "Real"
                    },
                    {
                        title: "CONSEJOS",
                        description: "💰 ¿Quieres ganar dinero mientras relajas?<br> Mantente AFK en las granjas de pesca o leche esparcidas por la<br> ciudad. ¡Cuanto más tiempo activo, mayor será tu ganancia!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 494.webp",
                        alt: "Consejos - Granjas y ganancias",
                        city: "Real"
                    },
                    {
                        title: "AYUDA",
                        description: "💡 ¿Tuviste algún problema o duda?<br> Presiona F5 para abrir un ticket con el equipo de Ciudad<br> Real. ¡Nuestro soporte siempre está listo para ayudarte!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 495.webp",
                        alt: "Cómo obtener ayuda",
                        city: "Real"
                    }
                ],
                keyboardConfig: {
                    'esc': 'Usa para abrir el Menú principal',
                    'f5': 'Usa para abrir un ticket de ayuda',
                    'tab': 'Usa para acceder a la Barra de items',
                    'caps-lock': 'Mantén presionado para hablar en la radio conectada.',
                    'r': 'Usa para recargar tu arma equipada.',
                    't': 'Usa para abrir el chat',
                    'p': 'Usa para abrir el mapa',
                    'k': 'Usa para usar el celular',
                    'home': 'Usa para aumentar/disminuir el volumen del micrófono',
                    'quote': 'Usa para abrir tu inventario'
                },
                socialLinks: {
                    youtube: '',
                    instagram: 'https://www.instagram.com/realrp.gg',
                    discord: 'https://discord.gg/realrp',
                    tiktok: 'https://www.tiktok.com/@realrp.gg '
                },
                staticTexts: {
                    welcomeText: 'Bienvenido a',
                    socialMediaTitle: 'Redes Sociales',
                    loadingText: 'Estamos cargando todo tu mapa',
                    ratingTitle: 'CLASIFICACIÓN INDICATIVA',
                    ratingReasons: 'Violencia, Drogas, Contenido sexual',
                    shortcutsDescription: 'Ver atajos pasa el mouse sobre las teclas destacadas',
                    shortcutsButtonText: 'Ver Atajos'
                }
            },
            "Prime": {
                video: `${this.cdnBase}/img/${this.legacyPath}/Prime/loading.mp4`,
                image: `${this.cdnBase}/img/${this.legacyPath}/Prime/banner_cd.png`,
                audio: `${this.cdnBase}/img/${this.legacyPath}/Prime/song.mp3`,
                trackArtist: "Ciudad Prime",
                slides: [
                    {
                        title: "SE BUENO",
                        description: "Sé educado, respeta a todos y especialmente a los principiantes<br> y juega limpio. Ciudad Prime es un RP de respeto y diversión!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp490.png",
                        alt: "Sé Bueno - Reglas de comportamiento",
                        city: "Prime"
                    },
                    {
                        title: "USO DE ARMAS",
                        description: "El uso de armas en Ciudad Prime está dividido en dos zonas:<br> Norte: uso libre de todas las armas.<br> Sur: solo pistolas permitidas.<br> ⚠️ Armas pesadas en el Sur pueden generar sanciones.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 491.webp",
                        alt: "Reglas de uso de armas",
                        city: "Prime"
                    },
                    {
                        title: "BAJA Y ROMPE",
                        description: "Baja y rompe está permitido en áreas remotas, excluyendo<br> vías principales de la ciudad. Permitido bajar y romper solo en<br> callejones, callejuelas, garajes e interiores.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp492.png",
                        alt: "Reglas de baja y rompe",
                        city: "Prime"
                    },
                    {
                        title: "CONSEJOS",
                        description: "🚗 ¿Quieres comprar tu primer vehículo?<br> Ve a la Concesionaria de Ciudad Prime y elige el modelo<br> que más te guste.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 493.webp",
                        alt: "Consejos - Comprar vehículo",
                        city: "Prime"
                    },
                    {
                        title: "CONSEJOS",
                        description: "💰 ¿Quieres ganar dinero mientras relajas?<br> Mantente AFK en las granjas de pesca o leche esparcidas por la<br> ciudad. ¡Cuanto más tiempo activo, mayor será tu ganancia!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 494.webp",
                        alt: "Consejos - Granjas y ganancias",
                        city: "Prime"
                    },
                    {
                        title: "AYUDA",
                        description: "💡 ¿Tuviste algún problema o duda?<br> Presiona F5 para abrir un ticket con el equipo de Ciudad<br> Prime. ¡Nuestro soporte siempre está listo para ayudarte!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 495.webp",
                        alt: "Cómo obtener ayuda",
                        city: "Prime"
                    }
                ],
                keyboardConfig: {
                    'esc': 'Usa para abrir el Menú principal',
                    'f5': 'Usa para abrir un ticket de ayuda',
                    'tab': 'Usa para acceder a la Barra de items',
                    'caps-lock': 'Mantén presionado para hablar en la radio conectada.',
                    'r': 'Usa para recargar tu arma equipada.',
                    't': 'Usa para abrir el chat',
                    'p': 'Usa para abrir el mapa',
                    'k': 'Usa para usar el celular',
                    'home': 'Usa para aumentar/disminuir el volumen del micrófono',
                    'quote': 'Usa para abrir tu inventario'
                },
                socialLinks: {
                    youtube: '',
                    instagram: '',
                    discord: 'https://discord.gg/ciudadprime',
                    tiktok: ''
                },
                staticTexts: {
                    welcomeText: 'Bienvenido a',
                    socialMediaTitle: 'Redes Sociales',
                    loadingText: 'Estamos cargando todo tu mapa',
                    ratingTitle: 'CLASIFICACIÓN INDICATIVA',
                    ratingReasons: 'Violencia, Drogas, Contenido sexual',
                    shortcutsDescription: 'Ver atajos pasa el mouse sobre las teclas destacadas',
                    shortcutsButtonText: 'Ver Atajos'
                }
            },
            "Royal": {
                video: `${this.cdnBase}/img/${this.legacyPath}/Royal/royal.mp4`,
                image: `${this.cdnBase}/img/${this.legacyPath}/Royal/banner_cd.png`,
                audio: `${this.cdnBase}/img/${this.legacyPath}/Royal/royal.mp3`,
                trackArtist: "Royal UK",
                slides: [
                    {
                        title: "BE NICE",
                        description: "Be polite, respect everyone and especially beginners,<br> and play fair. Royal City is an RP of respect and fun!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp490.png",
                        alt: "Be Nice - Behavior rules",
                        city: "Royal"
                    },
                    {
                        title: "WEAPON USAGE",
                        description: "Weapon usage in Royal City is divided into two zones:<br> North: all weapons allowed.<br> South: only pistols permitted.<br> ⚠️ Heavy weapons in the South may result in punishments.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 491.webp",
                        alt: "Weapon usage rules",
                        city: "Royal"
                    },
                    {
                        title: "DROP AND BREAK",
                        description: "Drop and break is allowed in remote areas, excluding<br> main city streets. Drop and break is only permitted in<br> alleys, side streets, garages, and interiors.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp492.png",
                        alt: "Drop and break rules",
                        city: "Royal"
                    },
                    {
                        title: "TIPS",
                        description: "🚗 Want to buy your first vehicle?<br> Go to the Royal City Dealership and choose the model<br> that best suits you.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 493.webp",
                        alt: "Tips - Buy vehicle",
                        city: "Royal"
                    },
                    {
                        title: "TIPS",
                        description: "💰 Want to earn while relaxing?<br> Stay AFK at fishing or milk farms scattered around the<br> city. The more time active, the greater your earnings!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 494.webp",
                        alt: "Tips - Farms and earnings",
                        city: "Royal"
                    },
                    {
                        title: "HELP",
                        description: "💡 Had a problem or question?<br> Press F5 to open a ticket with the <br>Royal City team. Our support is always ready to help you!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 495.webp",
                        alt: "How to get help",
                        city: "Royal"
                    }
                ],
                keyboardConfig: {
                    'esc': 'Use to open the Main menu',
                    'f5': 'Use to open a help ticket',
                    'tab': 'Use to access the Items hotbar',
                    'caps-lock': 'Hold to speak on the connected radio.',
                    'r': 'Use to reload your equipped weapon.',
                    't': 'Use to open the chat',
                    'p': 'Use to open the map',
                    'k': 'Use to use the phone',
                    'home': 'Use to increase/decrease microphone volume',
                    'quote': 'Use to open your inventory'
                },
                socialLinks: {
                    youtube: '',
                    instagram: 'https://www.instagram.com/royalcity.gg',
                    discord: 'https://discord.gg/royaluk',
                    tiktok: 'https://www.tiktok.com/@royalroleplay.gg'
                },
                staticTexts: {
                    welcomeText: 'Welcome to',
                    socialMediaTitle: 'Social Media',
                    loadingText: 'We are loading your entire map',
                    ratingTitle: 'CONTENT RATING',
                    ratingReasons: 'Violence, Drugs, Sexual content',
                    shortcutsDescription: 'View shortcuts hover over the highlighted keys',
                    shortcutsButtonText: 'View Shortcuts'
                }
            },
            "Grande": {
                video: `${this.cdnBase}/img/${this.legacyPath}/Grande/loading2.mp4`,
                image: `${this.cdnBase}/img/${this.legacyPath}/Grande/banner_cd.png`,
                audio: `${this.cdnBase}/img/${this.legacyPath}/Grande/song.mp3`,
                trackArtist: "Cidade Grande",
                slides: [
                    {
                        title: "SEJA GENTE BOA",
                        description: "🤝 Seja educado, respeite todos e principalmente os iniciantes<br> e jogue limpo. A Cidade Grande é um RP de respeito e diversão!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 490.webp",
                        alt: "Seja Gente Boa - Regras de comportamento",
                        city: "Grande"
                    },
                    {
                        title: "USO DE ARMAS",
                        description: "⚔️ O uso de armas na Cidade Grande é dividida em duas zonas:<br> Norte: uso liberado de todas as armas.<br> Sul: permitido apenas pistolas.<br> ⚠️ Armas pesadas no Sul podem gerar punições.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 491.webp",
                        alt: "Regras de uso de armas",
                        city: "Grande"
                    },
                    {
                        title: "DESCE E QUEBRA",
                        description: "⚔️ Desce e quebra é permitido em áreas remotas, excluindo<br> vias principais da cidade. Permitido desce e quebra apenas em<br> becos, vielas, garagens e interiores.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 492.webp",
                        alt: "Regras de desce e quebra",
                        city: "Grande"
                    },
                    {
                        title: "DICAS",
                        description: "🚗 Quer comprar o seu primeiro veículo?<br> Vá até a Concessionária da Cidade Grande e escolha o modelo<br> que mais combina com você.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 493.webp",
                        alt: "Dicas - Comprar veículo",
                        city: "Grande"
                    },
                    {
                        title: "DICAS",
                        description: "💰 Quer lucrar enquanto relaxa?<br> Fique AFK nos farms de pesca ou de leite espalhados pela<br> cidade. Quanto mais tempo ativo, maior o seu ganho!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 494.webp",
                        alt: "Dicas - Farms e ganhos",
                        city: "Grande"
                    },
                    {
                        title: "AJUDA",
                        description: "💡 Teve algum problema ou dúvida?<br> Aperte F5 para abrir um chamado com a equipe da Cidade<br> Grande. Nosso suporte está sempre pronto pra te ajudar!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 495.webp",
                        alt: "Como obter ajuda",
                        city: "Grande"
                    }
                ],
                keyboardConfig: {
                    'esc': 'Use para abrir o Menu principal',
                    'f5': 'Use para abrir um chamado de ajuda',
                    'tab': 'Use para acessar a Hotbar de itens',
                    'caps-lock': 'Segure para falar na rádio conectada.',
                    'r': 'Use para recarregar a sua arma equipada.',
                    't': 'Use para abrir o chat',
                    'p': 'Use para abrir o mapa',
                    'k': 'Use para usar o celular',
                    'home': 'Use para aumentar/dimunuir o volume do microfone',
                    'quote': 'Use para abrir o seu inventário'
                },
                socialLinks: {
                    youtube: '',
                    instagram: 'https://www.instagram.com/cidadegrande.gg/',
                    discord: 'https://discord.gg/granderp',
                    tiktok: ''
                },
                staticTexts: {
                    welcomeText: 'Bem vindo a',
                    socialMediaTitle: 'Redes Sociais',
                    loadingText: 'Estamos carregando todo o seu mapa',
                    ratingTitle: 'CLASSIFICAÇÃO INDICATIVA',
                    ratingReasons: 'Violência, Drogas, Conteúdo sexual',
                    shortcutsDescription: 'Passe o mouse sobre as teclas destacadas para saber mais',
                    shortcutsButtonText: 'Ver Atalhos'
                }
            },
            "Boomerang": {
                video: `${this.cdnBase}/img/${this.seasonPath}/Boomerang/loading.mp4`,
                image: `${this.cdnBase}/img/${this.seasonPath}/Boomerang/banner_cd.png`,
                audio: `${this.cdnBase}/img/${this.seasonPath}/Boomerang/music_boomerang.mp3`,
                trackArtist: "Boomerang RP",
                slides: [
                    {
                        title: "BE NICE",
                        description: "Be polite, respect everyone and especially beginners,<br> and play fair. Boomerang City is an RP of respect and fun!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp/Frame 490.webp",
                        alt: "Be Nice - Behavior rules",
                        city: "Boomerang"
                    },
                    {
                        title: "WEAPON USAGE",
                        description: "Weapon usage in Boomerang City is divided into two zones:<br> North: all weapons allowed.<br> South: only pistols permitted.<br> ⚠️ Heavy weapons in the South may result in punishments.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 491.webp",
                        alt: "Weapon usage rules",
                        city: "Boomerang"
                    },
                    {
                        title: "DROP AND BREAK",
                        description: "Drop and break is allowed in remote areas, excluding<br> main city streets. Drop and break is only permitted in<br> alleys, side streets, garages, and interiors.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/Eng/webp/Frame 492.webp",
                        alt: "Drop and break rules",
                        city: "Boomerang"
                    },
                    {
                        title: "TIPS",
                        description: "🚗 Want to buy your first vehicle?<br> Go to the Boomerang City Dealership and choose the model<br> that best suits you.",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 493.webp",
                        alt: "Tips - Buy vehicle",
                        city: "Boomerang"
                    },
                    {
                        title: "TIPS",
                        description: "💰 Want to earn while relaxing?<br> Stay AFK at fishing or milk farms scattered around the<br> city. The more time active, the greater your earnings!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 494.webp",
                        alt: "Tips - Farms and earnings",
                        city: "Boomerang"
                    },
                    {
                        title: "HELP",
                        description: "💡 Had a problem or question?<br> Press F5 to open a ticket with the<br> Boomerang City team. Our support is always ready to help you!",
                        image: "https://santaloading.roleplayrp.com/img/newloading/webp/Frame 495.webp",
                        alt: "How to get help",
                        city: "Boomerang"
                    }
                ],
                keyboardConfig: {
                    'esc': 'Use to open the Main menu',
                    'f5': 'Use to open a help ticket',
                    'tab': 'Use to access the Items hotbar',
                    'caps-lock': 'Hold to speak on the connected radio.',
                    'r': 'Use to reload your equipped weapon.',
                    't': 'Use to open the chat',
                    'p': 'Use to open the map',
                    'k': 'Use to use the phone',
                    'home': 'Use to increase/decrease microphone volume',
                    'quote': 'Use to open your inventory'
                },
                socialLinks: {
                    youtube: '',
                    instagram: 'https://www.instagram.com/boomerangroleplay/',
                    discord: 'https://discord.gg/boomerang-rp',
                    tiktok: ''
                },
                staticTexts: {
                    welcomeText: 'Welcome to',
                    socialMediaTitle: 'Social Media',
                    loadingText: 'We are loading your entire map',
                    ratingTitle: 'CONTENT RATING',
                    ratingReasons: 'Violence, Drugs, Sexual content',
                    shortcutsDescription: 'View shortcuts hover over the highlighted keys',
                    shortcutsButtonText: 'View Shortcuts'
                }
            }
        };
        this.configs["Base"] = this.configs["Santa"];
    }

    /**
     * Get complete configuration for a specific city
     * @param {string} cityName - Name of the city
     * @returns {Object|null} Complete city configuration or null if not found
     */
    getCityConfig(cityName) {
        if (!cityName || typeof cityName !== 'string') {
            console.warn('Invalid city name provided:', cityName);
            return null;
        }
        return this.configs[cityName] || this.configs["Santa"] || null;
    }

    /**
     * Get video URL for a city
     * @param {string} cityName - Name of the city
     * @returns {string|null} Video URL or null if not found
     */
    getVideoUrl(cityName) {
        const config = this.getCityConfig(cityName);
        return config ? config.video : null;
    }

    /**
     * Get music/audio URL for a city
     * @param {string} cityName - Name of the city
     * @returns {string|null} Audio URL or null if not found
     */
    getAudioUrl(cityName) {
        const config = this.getCityConfig(cityName);
        return config ? config.audio : null;
    }

    /**
     * Get image/banner URL for a city
     * @param {string} cityName - Name of the city
     * @returns {string|null} Image URL or null if not found
     */
    getImageUrl(cityName) {
        const config = this.getCityConfig(cityName);
        return config ? config.image : null;
    }

    /**
     * Get track artist name for a city
     * @param {string} cityName - Name of the city
     * @returns {string|null} Track artist name or null if not found
     */
    getTrackArtist(cityName) {
        const config = this.getCityConfig(cityName);
        return config ? (config.trackArtist || 'Santa Group') : 'Santa Group';
    }

    /**
     * Get slides for a city
     * @param {string} cityName - Name of the city
     * @returns {Array} Array of slide objects or empty array if not found
     */
    getSlides(cityName) {
        const config = this.getCityConfig(cityName);
        return config && Array.isArray(config.slides) ? config.slides : [];
    }

    /**
     * Get keyboard configuration for a city
     * @param {string} cityName - Name of the city
     * @returns {Object} Keyboard configuration object or empty object if not found
     */
    getKeyboardConfig(cityName) {
        const config = this.getCityConfig(cityName);
        return config && config.keyboardConfig ? config.keyboardConfig : {};
    }

    /**
     * Get social links for a city
     * @param {string} cityName - Name of the city
     * @returns {Object} Social links object or empty object if not found
     */
    getSocialLinks(cityName) {
        const config = this.getCityConfig(cityName);
        return config && config.socialLinks ? config.socialLinks : {};
    }

    /**
     * Get Santa Group social media links (for Brazilian cities)
     * @returns {Object} Santa Group social links object
     */
    getSantaGroupLinks() {
        return this.santaGroupLinks;
    }

    /**
     * Get static texts for a city
     * @param {string} cityName - Name of the city
     * @returns {Object} Static texts object or default object if not found
     */
    getStaticTexts(cityName) {
        const config = this.getCityConfig(cityName);
        if (config && config.staticTexts) {
            return config.staticTexts;
        }
        // Return default texts if not found
        return {
            welcomeText: 'Bem vindo a',
            socialMediaTitle: 'Redes Sociais',
            loadingText: 'Estamos carregando todo o seu mapa',
            ratingTitle: 'CLASSIFICAÇÃO INDICATIVA',
            ratingReasons: 'Violência, Drogas, Conteúdo sexual',
            shortcutsDescription: 'Passe o mouse sobre as teclas destacadas para saber mais',
            shortcutsButtonText: 'Ver Atalhos'
        };
    }

    /**
     * Get all available cities
     * @returns {string[]} Array of city names
     */
    getAvailableCities() {
        return Object.keys(this.configs);
    }

    /**
     * Check if city exists in configuration
     * @param {string} cityName - Name of the city
     * @returns {boolean} True if city exists
     */
    hasCity(cityName) {
        return cityName in this.configs;
    }

    /**
     * Apply static texts to DOM elements
     * @param {string} cityName - Name of the city
     * @param {Object} staticTexts - Static texts configuration
     * @param {boolean} isRetry - Whether this is a retry attempt
     */
    applyStaticTexts(cityName, staticTexts, isRetry = false) {
        if (!staticTexts) {
            if (!isRetry) {
                console.warn(`No staticTexts configured for city: ${cityName}`);
            }
            return;
        }

        let updatedCount = 0;

        // Update welcome text
        const welcomeTextEl = document.querySelector('#welcomeContent .welcome-text');
        if (welcomeTextEl) {
            if (staticTexts.welcomeText) {
                welcomeTextEl.textContent = staticTexts.welcomeText;
                updatedCount++;
                // Hide skeleton and show content when welcome text is loaded
                const skeleton = document.querySelector('#welcomeSkeleton');
                const content = document.querySelector('#welcomeContent');
                if (skeleton) skeleton.classList.add('skeleton-hidden');
                if (content) content.classList.remove('skeleton-hidden');
            }
        }

        // Update social media title
        const socialTitleEl = document.querySelector('.section-title');
        if (socialTitleEl) {
            if (staticTexts.socialMediaTitle) {
                socialTitleEl.textContent = staticTexts.socialMediaTitle;
                updatedCount++;
            }
        }

        // Update loading text — translate both paragraphs. The first uses the
        // configured staticTexts.loadingText; the second ("Loading GTA V map...")
        // is translated based on the language detected from the first.
        const loadingTextContainer = document.querySelector('.loading-text');
        if (loadingTextContainer) {
            const paragraphs = loadingTextContainer.querySelectorAll('p');
            if (paragraphs.length > 0) {
                if (staticTexts.loadingText) {
                    paragraphs[0].textContent = staticTexts.loadingText;

                    if (paragraphs.length > 1) {
                        const loadingSubtitles = {
                            pt: 'Carregando o mapa do GTA V...',
                            en: 'Loading GTA V map...',
                            es: 'Cargando el mapa de GTA V...',
                            fr: 'Chargement de la carte GTA V...',
                            ar: 'جاري تحميل خريطة GTA V...'
                        };
                        const lang = (typeof detectLanguage === 'function')
                            ? detectLanguage(staticTexts.loadingText)
                            : 'pt';
                        paragraphs[1].textContent = loadingSubtitles[lang] || loadingSubtitles.pt;
                        paragraphs[1].style.display = '';
                    }

                    updatedCount++;
                }
            }
        }

        // Update rating title
        const ratingTitleEl = document.querySelector('.rating-title');
        if (ratingTitleEl) {
            if (staticTexts.ratingTitle) {
                ratingTitleEl.textContent = staticTexts.ratingTitle;
                updatedCount++;
            }
        }

        // Update rating reasons
        const ratingReasonsEl = document.querySelector('.rating-reasons');
        if (ratingReasonsEl) {
            if (staticTexts.ratingReasons) {
                ratingReasonsEl.textContent = staticTexts.ratingReasons;
                updatedCount++;
            }
        }

        // Update shortcuts description
        const shortcutsDescEl = document.getElementById('keybindDescription');
        if (shortcutsDescEl) {
            if (staticTexts.shortcutsDescription) {
                shortcutsDescEl.textContent = staticTexts.shortcutsDescription;
                updatedCount++;

                // Also update the defaultText in KeyboardTooltipManager if it exists
                if (window.keyboardTooltipManager) {
                    window.keyboardTooltipManager.defaultText = staticTexts.shortcutsDescription;
                    // If setDefaultContent was already called, update it directly
                    if (window.keyboardTooltipManager.tooltipDescription) {
                        window.keyboardTooltipManager.tooltipDescription.textContent = staticTexts.shortcutsDescription;
                    }
                }
            }
        }

        // Update KeyboardTooltipManager defaultText even if element wasn't found (for future use)
        if (staticTexts.shortcutsDescription && window.keyboardTooltipManager) {
            window.keyboardTooltipManager.defaultText = staticTexts.shortcutsDescription;
        }

        // Update shortcuts button text (if it exists)
        const shortcutsBtn = document.getElementById('shortcutsBtn');
        if (shortcutsBtn && staticTexts.shortcutsButtonText) {
            // Find text node after the span with icon
            const iconSpan = shortcutsBtn.querySelector('.shortcuts-icon');
            if (iconSpan) {
                // Remove existing text nodes after the icon
                let nextSibling = iconSpan.nextSibling;
                while (nextSibling && nextSibling.nodeType === Node.TEXT_NODE) {
                    const toRemove = nextSibling;
                    nextSibling = nextSibling.nextSibling;
                    shortcutsBtn.removeChild(toRemove);
                }
                // Add new text
                shortcutsBtn.appendChild(document.createTextNode(' ' + staticTexts.shortcutsButtonText));
                updatedCount++;
            } else {
                // Fallback: replace all text content
                const textNode = Array.from(shortcutsBtn.childNodes).find(node => node.nodeType === Node.TEXT_NODE);
                if (textNode) {
                    textNode.textContent = ' ' + staticTexts.shortcutsButtonText;
                    updatedCount++;
                } else {
                    shortcutsBtn.appendChild(document.createTextNode(' ' + staticTexts.shortcutsButtonText));
                    updatedCount++;
                }
            }
        }

        // Retry for elements that might not be ready yet (only once)
        if (!isRetry) {
            setTimeout(() => {
                // Check if any elements are still missing
                const missingWelcome = !document.querySelector('#welcomeContent .welcome-text');
                const missingSocial = !document.querySelector('.section-title');
                const missingRating = !document.querySelector('.rating-title');
                const missingShortcuts = !document.getElementById('keybindDescription');

                if (missingWelcome || missingSocial || missingRating || missingShortcuts) {
                    this.applyStaticTexts(cityName, staticTexts, true);
                } else if (updatedCount < 6) {
                    // Even if elements exist, retry if not all were updated
                    this.applyStaticTexts(cityName, staticTexts, true);
                }

                // Always retry shortcutsDescription after KeyboardTooltipManager initializes
                if (staticTexts.shortcutsDescription) {
                    setTimeout(() => {
                        const shortcutsDescEl = document.getElementById('keybindDescription');
                        if (shortcutsDescEl) {
                            shortcutsDescEl.textContent = staticTexts.shortcutsDescription;
                        }
                        if (window.keyboardTooltipManager) {
                            window.keyboardTooltipManager.defaultText = staticTexts.shortcutsDescription;
                            if (window.keyboardTooltipManager.tooltipDescription) {
                                window.keyboardTooltipManager.tooltipDescription.textContent = staticTexts.shortcutsDescription;
                            }
                        }
                    }, 600);
                }
            }, 500);
        }
    }

    /**
     * Apply city configuration to the application
     * This method applies all configurations (video, music, slides, keyboard, social links) for a city
     * @param {string} cityName - Name of the city
     * @returns {boolean} True if configuration was applied successfully
     */
    applyCityConfig(cityName) {
        const config = this.getCityConfig(cityName);
        if (!config) {
            console.warn(`City configuration not found for: ${cityName}`);
            return false;
        }

        // Video is loaded by VideoManager automatically, no need to load it here
        // This prevents duplicate video loading

        // Music is loaded by MusicPlayer automatically, no need to load it here
        // This prevents duplicate music loading
        // Update MusicPlayer if it exists and city name matches
        if (config.audio && window.loadingScreenApp?.musicPlayer) {
            window.loadingScreenApp.musicPlayer.updateMusicFromConfig(cityName, config.audio);
        }

        // Apply slides
        if (Array.isArray(config.slides) && config.slides.length > 0) {
            console.log(`Applying ${config.slides.length} slides for city: ${cityName}`);

            // Wait for vipSlider to be ready, or create it if needed
            let slideRetries = 0;
            const applySlides = () => {
                const app = window.loadingScreenApp;
                if (!app || !app.vipSlider) {
                    if (++slideRetries <= 20) {
                        setTimeout(applySlides, 200);
                    }
                    return;
                }

                console.log('vipSlider is ready, applying slides...');

                // Destroy existing slides
                if (app.vipSlider.destroy) {
                    app.vipSlider.destroy();
                }
                app.vipSlider.slides = [];
                app.vipSlider.slidesData = [];
                app.vipSlider.currentSlide = 0;

                // Clear slider track
                if (app.vipSlider.sliderTrack) {
                    app.vipSlider.sliderTrack.innerHTML = '';
                }

                config.slides.forEach((slideData, index) => {
                    if (!slideData?.image) {
                        console.warn(`Slide ${index} has no image, skipping`);
                        return;
                    }

                    console.log(`Creating slide ${index + 1}:`, slideData.title || 'Untitled');

                    app.vipSlider.slidesData.push({
                        title: slideData.title || '',
                        description: slideData.description || '',
                        image: slideData.image,
                        alt: slideData.alt || '',
                        city: slideData.city || cityName
                    });

                    const slide = document.createElement('div');
                    slide.className = 'slider-slide';
                    slide.dataset.index = index;

                    const img = document.createElement('img');
                    img.src = slideData.image;
                    img.alt = slideData.alt || slideData.city || `Slide ${index + 1}`;
                    img.onerror = () => {
                        console.warn(`Failed to load slide image: ${slideData.image}`);
                        slide.style.display = 'none';
                    };

                    const overlay = document.createElement('div');
                    overlay.className = 'slider-overlay';

                    slide.appendChild(img);
                    slide.appendChild(overlay);

                    if (app.vipSlider.sliderTrack) {
                        app.vipSlider.sliderTrack.appendChild(slide);
                    }
                    app.vipSlider.slides.push(slide);
                });

                if (app.vipSlider.slides.length > 0) {
                    console.log(`Successfully created ${app.vipSlider.slides.length} slides`);
                    if (app.vipSlider.createPaginationDots) {
                        app.vipSlider.createPaginationDots();
                    }
                    if (app.vipSlider.updateSlideContent) {
                        app.vipSlider.updateSlideContent();
                    }

                    // Wait for first slide image to load before showing sidebar
                    const firstSlide = app.vipSlider.slides[0];
                    const firstSlideImg = firstSlide ? firstSlide.querySelector('img') : null;

                    if (firstSlideImg) {
                        // Hide sidebar initially
                        const sidebar = document.querySelector('.sidebar');
                        if (sidebar) {
                            sidebar.style.opacity = '0';
                            sidebar.style.visibility = 'hidden';
                            console.log('Sidebar hidden, waiting for first slide to load...');
                        }

                        // Show sidebar when first image loads
                        const showSidebarWhenReady = () => {
                            if (sidebar) {
                                sidebar.style.opacity = '1';
                                sidebar.style.visibility = 'visible';
                                sidebar.style.transition = 'opacity 0.5s ease-in-out, visibility 0.5s ease-in-out';
                                console.log('First slide loaded, showing sidebar');

                                // Show content card with animation
                                const contentCard = document.querySelector('.content-card');
                                if (contentCard) {
                                    contentCard.classList.add('loaded', 'fade-in');
                                }
                            }

                            // Start autoplay after sidebar is shown
                            if (app.vipSlider.startAutoPlay) {
                                app.vipSlider.startAutoPlay();
                            }
                        };

                        // Check if image is already loaded
                        if (firstSlideImg.complete && firstSlideImg.naturalHeight !== 0) {
                            console.log('First slide image already loaded');
                            showSidebarWhenReady();
                        } else {
                            // Wait for image to load
                            firstSlideImg.onload = () => {
                                console.log('First slide image loaded');
                                showSidebarWhenReady();
                            };
                            firstSlideImg.onerror = () => {
                                console.warn('First slide image failed to load, showing sidebar anyway');
                                showSidebarWhenReady();
                            };
                        }
                    } else {
                        // Fallback: show sidebar even if no image found
                        const sidebar = document.querySelector('.sidebar');
                        if (sidebar) {
                            sidebar.style.opacity = '1';
                            sidebar.style.visibility = 'visible';
                        }
                        if (app.vipSlider.startAutoPlay) {
                            app.vipSlider.startAutoPlay();
                        }
                    }
                } else {
                    console.warn('No slides were created');
                }
            };

            // Try to apply slides immediately, or wait for vipSlider
            applySlides();
        } else {
            console.warn(`No slides found in config for city: ${cityName}`);
        }

        // Apply keyboard configuration
        this.applyKeyboardConfig(cityName);

        console.log(`City configuration applied for: ${cityName}`);
        return true;
    }

    /**
     * Apply only slides for a city (without video/music)
     * This is used to retry applying slides without reloading video
     * @param {string} cityName - Name of the city
     * @returns {boolean} True if slides were applied successfully
     */
    applySlidesOnly(cityName) {
        const config = this.getCityConfig(cityName);
        if (!config) {
            console.warn(`City configuration not found for: ${cityName}`);
            return false;
        }

        // Apply slides only
        if (Array.isArray(config.slides) && config.slides.length > 0) {
            let slideRetries = 0;
            const applySlides = () => {
                const app = window.loadingScreenApp;
                // Wait for vipSlider to be ready, or create it if needed
                if (!app || !app.vipSlider) {
                    if (++slideRetries <= 20) {
                        setTimeout(applySlides, 300);
                    }
                    return;
                }

                console.log('vipSlider is ready, applying slides...');

                // Destroy existing slides
                if (app.vipSlider.destroy) {
                    app.vipSlider.destroy();
                }
                app.vipSlider.slides = [];
                app.vipSlider.slidesData = [];
                app.vipSlider.currentSlide = 0;

                // Clear slider track
                if (app.vipSlider.sliderTrack) {
                    app.vipSlider.sliderTrack.innerHTML = '';
                }

                config.slides.forEach((slideData, index) => {
                    if (!slideData?.image) {
                        console.warn(`Slide ${index} has no image, skipping`);
                        return;
                    }

                    console.log(`Creating slide ${index + 1}:`, slideData.title || 'Untitled');

                    app.vipSlider.slidesData.push({
                        title: slideData.title || '',
                        description: slideData.description || '',
                        image: slideData.image,
                        alt: slideData.alt || '',
                        city: slideData.city || cityName
                    });

                    const slide = document.createElement('div');
                    slide.className = 'slider-slide';
                    slide.dataset.index = index;

                    const img = document.createElement('img');
                    img.src = slideData.image;
                    img.alt = slideData.alt || slideData.city || `Slide ${index + 1}`;
                    img.onerror = () => {
                        console.warn(`Failed to load slide image: ${slideData.image}`);
                        slide.style.display = 'none';
                    };

                    const overlay = document.createElement('div');
                    overlay.className = 'slider-overlay';

                    slide.appendChild(img);
                    slide.appendChild(overlay);

                    if (app.vipSlider.sliderTrack) {
                        app.vipSlider.sliderTrack.appendChild(slide);
                    }
                    app.vipSlider.slides.push(slide);
                });

                if (app.vipSlider.slides.length > 0) {
                    console.log(`Successfully created ${app.vipSlider.slides.length} slides`);
                    if (app.vipSlider.createPaginationDots) {
                        app.vipSlider.createPaginationDots();
                    }
                    if (app.vipSlider.updateSlideContent) {
                        app.vipSlider.updateSlideContent();
                    }

                    // Wait for first slide image to load before showing sidebar
                    const firstSlide = app.vipSlider.slides[0];
                    const firstSlideImg = firstSlide ? firstSlide.querySelector('img') : null;

                    if (firstSlideImg) {
                        // Hide sidebar initially
                        const sidebar = document.querySelector('.sidebar');
                        if (sidebar) {
                            sidebar.style.opacity = '0';
                            sidebar.style.visibility = 'hidden';
                            console.log('Sidebar hidden, waiting for first slide to load...');
                        }

                        // Show sidebar when first image loads
                        const showSidebarWhenReady = () => {
                            if (sidebar) {
                                sidebar.style.opacity = '1';
                                sidebar.style.visibility = 'visible';
                                sidebar.style.transition = 'opacity 0.5s ease-in-out, visibility 0.5s ease-in-out';
                                console.log('First slide loaded, showing sidebar');

                                // Show content card with animation
                                const contentCard = document.querySelector('.content-card');
                                if (contentCard) {
                                    contentCard.classList.add('loaded', 'fade-in');
                                }
                            }

                            // Start autoplay after sidebar is shown
                            if (app.vipSlider.startAutoPlay) {
                                app.vipSlider.startAutoPlay();
                            }
                        };

                        // Check if image is already loaded
                        if (firstSlideImg.complete && firstSlideImg.naturalHeight !== 0) {
                            console.log('First slide image already loaded');
                            showSidebarWhenReady();
                        } else {
                            // Wait for image to load
                            firstSlideImg.onload = () => {
                                console.log('First slide image loaded');
                                showSidebarWhenReady();
                            };
                            firstSlideImg.onerror = () => {
                                console.warn('First slide image failed to load, showing sidebar anyway');
                                showSidebarWhenReady();
                            };
                        }
                    } else {
                        // Fallback: show sidebar even if no image found
                        const sidebar = document.querySelector('.sidebar');
                        if (sidebar) {
                            sidebar.style.opacity = '1';
                            sidebar.style.visibility = 'visible';
                        }
                        if (app.vipSlider.startAutoPlay) {
                            app.vipSlider.startAutoPlay();
                        }
                    }
                } else {
                    console.warn('No slides were created');
                }
            };

            // Try to apply slides immediately, or wait for vipSlider
            applySlides();
        } else {
            console.warn(`No slides found in config for city: ${cityName}`);
        }

        return true;
    }

    /**
     * Apply keyboard configuration
     * @param {string} cityName - Name of the city
     */
    applyKeyboardConfig(cityName) {
        const config = this.getCityConfig(cityName);
        if (!config) return;

        // Apply keyboard configuration
        if (config.keyboardConfig) {
            const tooltipManager = window.keyboardTooltipManager;
            if (tooltipManager) {
                tooltipManager.updateKeyboardShortcuts(config.keyboardConfig);
            } else {
                // If not initialized yet, wait a bit and try again
                setTimeout(() => {
                    const tooltipManagerRetry = window.keyboardTooltipManager;
                    if (tooltipManagerRetry) {
                        tooltipManagerRetry.updateKeyboardShortcuts(config.keyboardConfig);
                    }
                }, 600);
            }
        }

        // Apply social links
        if (config.socialLinks) {
            if (typeof updateSocialLinks === 'function') {
                updateSocialLinks(config.socialLinks, cityName);
            }
        }

        // Update city name dynamically (always, regardless of staticTexts)
        const cityNameEl = document.querySelector('#welcomeContent .city-name');
        console.log('Updating city name:', cityName, 'Element found:', !!cityNameEl);
        if (cityNameEl) {
            cityNameEl.textContent = cityName;
            console.log('City name updated successfully to:', cityName);
            // Hide skeleton and show content when city name is loaded
            const skeleton = document.querySelector('#welcomeSkeleton');
            const content = document.querySelector('#welcomeContent');
            if (skeleton) skeleton.classList.add('skeleton-hidden');
            if (content) content.classList.remove('skeleton-hidden');
        } else {
            console.warn('City name element (#welcomeContent .city-name) not found in DOM');
            // Try again after a short delay in case DOM isn't ready
            setTimeout(() => {
                const retryCityNameEl = document.querySelector('#welcomeContent .city-name');
                if (retryCityNameEl) {
                    retryCityNameEl.textContent = cityName;
                    console.log('City name updated on retry to:', cityName);
                    const skeleton = document.querySelector('#welcomeSkeleton');
                    const content = document.querySelector('#welcomeContent');
                    if (skeleton) skeleton.classList.add('skeleton-hidden');
                    if (content) content.classList.remove('skeleton-hidden');
                }
            }, 100);
        }

        // Apply static texts (with delay to ensure DOM is ready)
        if (config.staticTexts) {
            // Try immediately
            this.applyStaticTexts(cityName, config.staticTexts);

            // Also try after DOM is fully ready
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', () => {
                    console.log('DOMContentLoaded - reapplying static texts');
                    this.applyStaticTexts(cityName, config.staticTexts);
                });
            } else {
                // DOM already ready, try again after a short delay
                setTimeout(() => {
                    console.log('DOM ready - reapplying static texts');
                    this.applyStaticTexts(cityName, config.staticTexts);
                }, 200);
            }
        }

        console.log(`City configuration applied for: ${cityName}`);
        return true;
    }
}

// Create global instance
const cityConfigManager = new CityConfigManager();

// Legacy compatibility - keep the old format for existing code
// Use existing cityConfigs if already declared in HTML, otherwise create new one
if (typeof cityConfigs === 'undefined') {
    var cityConfigs = {};
}
// Clear and rebuild the object
Object.keys(cityConfigs).forEach(key => delete cityConfigs[key]);
cityConfigManager.getAvailableCities().forEach(city => {
    cityConfigs[city] = cityConfigManager.getVideoUrl(city);
});

// Export for different module systems
if (typeof window !== 'undefined') {
    window.cityConfigManager = cityConfigManager;
    window.cityConfigs = cityConfigs;
}

if (typeof module !== 'undefined' && module.exports) {
    module.exports = { CityConfigManager, cityConfigManager, cityConfigs };
}

// ES6 export removed - using regular script tag instead of module
// If you need ES6 modules, load this file with type="module"
// export default cityConfigManager;
