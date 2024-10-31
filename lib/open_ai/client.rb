require "net/http"

module OpenAi
  class Client
    BASE_URL = "https://api.openai.com/v1"
    ENDPOINT = "/chat/completions"
    AI_MODEL = "gpt-4o"

    PROMPT = """
      You are a helpful assistant designed to generate a title for my task based on the provided description, example:
      Description: \"Need to go out with my dog today and go shopping for my mother\"
      Your output: \"Go out with dog and go shopping\"
      Avoid to put \"title:\" in your reply, just reply in a succint and short way the idea of the entire description
    """

    def initialize
      @api_key = ENV.fetch("OPENAI_API_KEY")
    end

    def call(description:)
      @description = description
      uri = URI(BASE_URL + ENDPOINT)

      request = Net::HTTP::Post.new(uri)
      request["Authorization"] = "Bearer #{@api_key}"
      request["Content-Type"] = "application/json"
      request.body = { model: AI_MODEL, messages: prompt }.to_json

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      ResponseHandler.new(response)
    end

    private

    def prompt
      [
        { role: :user, content: PROMPT },
        { role: :user, content: "description: #{@description}" }
      ]
    end
  end
end
