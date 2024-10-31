require 'rails_helper'

RSpec.describe OpenAi::ResponseHandler do
  describe '#success?' do
    context 'when response is a success' do
      let(:response) { instance_double(Net::HTTPSuccess) }

      it 'returns true' do
        allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)

        handler = OpenAi::ResponseHandler.new(response)
        expect(handler.success?).to be true
      end
    end

    context 'when response is not a success' do
      let(:response) { instance_double(Net::HTTPResponse) }

      it 'returns false' do
        allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)

        handler = OpenAi::ResponseHandler.new(response)
        expect(handler.success?).to be false
      end
    end
  end

  describe '#content' do
    context 'when the response is a success' do
      let(:response_body) { { 'choices' => [ { 'message' => { 'content' => 'Sample content' } } ] } }
      let(:response) { instance_double(Net::HTTPSuccess, body: response_body.to_json) }
      let(:handler) { OpenAi::ResponseHandler.new(response) }

      before do
        allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
      end

      it 'returns the content from the response' do
        expect(handler.content).to eq('Sample content')
      end
    end

    context 'when the response is not a success' do
      let(:response) { instance_double(Net::HTTPResponse) }
      let(:handler) { OpenAi::ResponseHandler.new(response) }

      before do
        allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
      end

      it 'returns nil' do
        expect(handler.content).to be_nil
      end
    end
  end
end
