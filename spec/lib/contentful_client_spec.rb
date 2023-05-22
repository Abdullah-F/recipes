require 'rails_helper'

describe ContentfulClient do
  let(:page_limit) { 2 }
  before do
    stub_const('ContentfulClient::PAGE_LIMIT', page_limit)
  end
  describe '.get_recipes' do
    subject { described_class.get_recipes }
    context 'when fetching the first page', :vcr do
      it 'skips zero entries' do
        expect(ContentfulClient.connection).to receive(:entries).with(
          content_type: 'recipe',
          limit: described_class::PAGE_LIMIT,
          skip: 0
        ).and_call_original

        expect(subject.size).to eq page_limit
      end
    end

    context 'when fetching the second page', :vcr do
      subject { described_class.get_recipes(1) }
      it 'skips skips 2 entries' do
        expect(ContentfulClient.connection).to receive(:entries).with(
          content_type: 'recipe',
          limit: described_class::PAGE_LIMIT,
          skip: 2
        ).and_call_original

        expect(subject.size).to eq page_limit
      end
    end

    context 'when contentful bad request error happens', :vcr do
      before do
        stub_const('ContentfulClient::RECIPES_CONTENT_TYPE', 'invalid_type')
      end
      it 'raises a contentful sever error' do
        expect { subject }.to raise_error(Contentful::BadRequest)
      end
    end
  end

  describe '.get_recipe' do
    subject { described_class.get_recipe(recipe_id) }
    context 'when valid request', :vcr do
      let(:recipe_id) { '4dT8tcb6ukGSIg2YyuGEOm' }
      it 'returns the recipe entry' do
        expect(ContentfulClient.connection).to receive(:entries).with(
          content_type: 'recipe',
          limit: described_class::PAGE_LIMIT,
          skip: 0,
          'sys.id' => recipe_id
        ).and_call_original

        expect(subject).to be_a(Contentful::Entry)
      end
    end

    context 'with invalid recipe_id', :vcr do
      let(:recipe_id) { 'invalid_id' }
      it 'returns nil' do
        expect(ContentfulClient.connection).to receive(:entries).with(
          content_type: 'recipe',
          limit: described_class::PAGE_LIMIT,
          skip: 0,
          'sys.id' => recipe_id
        ).and_call_original

        expect(subject).to be_nil
      end
    end
  end
end
