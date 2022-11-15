class  PoltergeistPage < SitePrism::Page
    set_url "/"

    def teste
        page.driver.network_traffic.each do |request|
            request.response_parts.each do |response|
                puts "\n URL #{response.url}: \n Status #{response.status}"
            end
        end
    end    
end