module Discord
    def discord_send_embed(mensagem)
        webHookUrl = 'SUA URL WEBHOOK AQUI'.freeze

        client = Discordrb::Webhooks::Client.new(url: webHookUrl)
        client.execute do |builder|

            builder.content = mensagem

            builder.add_embed do |embed|
                embed.color = 5039556
                embed.title = "Funcionalidade: #{$feature}"
                embed.description = "Cenário: #{$scenario}"
                embed.timestamp = Time.now
            end
        end        
    end    
end