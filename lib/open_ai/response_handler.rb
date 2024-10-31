module OpenAi
  class ResponseHandler
    def initialize(response)
      @response = response
    end

    def success?
      @response.is_a?(Net::HTTPSuccess)
    end

    def content
      return unless success?

      JSON.parse(@response.body)["choices"][0]["message"]["content"]
    end
  end
end
