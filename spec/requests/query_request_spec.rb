require 'rails_helper'

RSpec.describe 'Query requests', type: :request, vcr: true do

  def message
    JSON.parse(response.body)['message']
  end

  it 'should return an error without a query param' do
    post '/api/v1/query'

    expect(response.status).to eq 422
    expect(message).to eq 'You must pass a query in the query param'
  end

  it 'should return a message if it can not understand the intent' do
    post '/api/v1/query', params: { query: 'irrelevant' }
    expect(response).to be_success
    expect(message).to include "Sorry, but I couldn't tell what you wanted."
  end

  it 'should return a message if it cannot determine the substance' do
    post '/api/v1/query', params: { query: 'Tell me about the sky' }
    expect(response).to be_success
    expect(message).to include "I'm sorry, but I don't have any information about that"
  end

  it 'should return the substance profile if the intent is substance_profile' do
    Substance.create(name: 'LSD')
    post '/api/v1/query', params: { query: 'Tell me about LSD' }

    expect(response).to be_success
    expect(message).to include 'LSD is a'
  end
end
