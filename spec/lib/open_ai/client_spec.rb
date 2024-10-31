require 'rails_helper'

RSpec.describe OpenAi::Client do
  let(:api_key) { 'test_api_key' }
  let(:description) { 'Need to go out with my dog today and go shopping for my mother' }
  let(:client) { described_class.new }
  let(:uri) { URI("#{OpenAi::Client::BASE_URL}#{OpenAi::Client::ENDPOINT}") }

  before do
    allow(ENV).to receive(:fetch).with('OPENAI_API_KEY').and_return(api_key)
  end

  describe '#call' do
    let(:response_body) { { choices: [ { message: { content: 'Go out with dog and go shopping' } } ] }.to_json }
    let(:http_response) { instance_double(Net::HTTPSuccess, body: response_body) }
    let(:request_double) { instance_double(Net::HTTP::Post) }

    before do
      allow(Net::HTTP).to receive(:start).and_yield(double('http', request: response_body)).and_return(http_response)
      allow(Net::HTTP::Post).to receive(:new).and_return(request_double)
      allow(http_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
      allow(request_double).to receive(:body=)
      allow(request_double).to receive(:[]=)
    end

    it 'sends a POST request to the OpenAI API with the correct headers and body' do
      client.call(description: description)

      expected_body = {
        model: OpenAi::Client::AI_MODEL,
        messages: [
          { role: 'user', content: OpenAi::Client::PROMPT },
          { role: 'user', content: "description: #{description}" }
        ]
      }.to_json

      expect(Net::HTTP::Post).to have_received(:new).with(uri)
      expect(request_double).to have_received(:body=).with(expected_body)
      expect(request_double).to have_received(:[]=).with('Content-Type', 'application/json')
      expect(request_double).to have_received(:[]=).with('Authorization', 'Bearer test_api_key')
    end

    it 'returns a ResponseHandler instance with the HTTP response' do
      result = client.call(description: description)

      expect(result).to be_a(OpenAi::ResponseHandler)
      expect(result.success?).to be true
      expect(result.content).to eq('Go out with dog and go shopping')
    end
  end
end
