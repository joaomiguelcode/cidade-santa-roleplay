window.addEventListener( 'message', async function( event )
{
    const { type, invokingResource } = event.data;

    if ( type === 'fetch' )
    {
        const {
            url,
            input,
            method,
            headers,

            callbackUri
        } = event.data.data;

        // Url para onde vamos enviar a resposta do fetch
        const callbackUrl = `https://${ invokingResource }/${ callbackUri }`;

        try
        {
            const fetchOptions = {
                method,
                headers,
                body: JSON.stringify( input ),
            };

            const response = await fetch( url, fetchOptions );

            const responseBody = await response.text();

            if ( !response.ok )
            {
                console.error( `[sx.nui.fetch] ${ method } ${ url } -> HTTP ${ response.status }: ${ responseBody }` );
            }

            fetch( callbackUrl, {
                method: 'POST',

                body: JSON.stringify({
                    responseHeaders : response.headers,
                    status          : response.status,
                    body            : response.ok ? responseBody : null,
                    errorData       : response.ok ? null         : responseBody,
                }),
            });
        }
        catch( e )
        {
            // "Failed to fetch" sem mais contexto é inútil pra debugar. Logamos
            // url/método/erro no console do CEF (F8) e devolvemos o mesmo detalhe
            // no errorData pra aparecer no log do servidor.
            const reason = e instanceof Error ? `${ e.name }: ${ e.message }` : String( e );
            const detail = `[sx.nui.fetch] ${ method } ${ url } FAILED -> ${ reason }`;

            console.error( detail );

            fetch( callbackUrl, {
                method: 'POST',

                body: JSON.stringify({
                    responseHeaders : { },
                    status          : 5001, // Custom error code
                    body            : null,
                    errorData       : detail,
                }),
            });
        }
    }
});
