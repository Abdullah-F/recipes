require 'rails_helper'

describe ContentfulRecipe do
  describe '#chef_name' do
    context 'when present' do
      subject do # could be dried further accross examples by extracting the recipe id into a let varaible
        ContentfulClient.get_recipe('2E8bc3VcJmA8OgmQsageas').chef_name
      end

      it 'returns the chef_name', :vcr do
        expect(subject).to eq('Mark Zucchiniberg')
      end
    end

    context 'when present' do
      subject do
        ContentfulClient.get_recipe('5jy9hcMeEgQ4maKGqIOYW6').chef_name
      end

      it 'returns Anonymous name', :vcr do
        expect(subject).to eq('Anonymous Chef Lol')
      end
    end
  end

  describe '#tags' do
    context 'when present' do
      subject do
        ContentfulClient.get_recipe('437eO3ORCME46i02SeCW46').tags
      end

      it 'returns the tags string', :vcr do
        expect(subject).to eq('gluten free, healthy')
      end
    end

    context 'when not present' do
      subject do
        ContentfulClient.get_recipe('5jy9hcMeEgQ4maKGqIOYW6').tags
      end

      it 'returns TBD', :vcr do
        expect(subject).to eq('TBD')
      end
    end
  end

  describe '#description_html' do
    subject do
      ContentfulClient.get_recipe('5jy9hcMeEgQ4maKGqIOYW6')
    end

    let(:description_html) do
      Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
                         .render(subject.description_markdown)
                         .html_safe
    end
    it 'returns the markdown description as html', :vcr do
      expect(subject.description_html).to eq(description_html)
    end
  end

  describe '#title' do
    subject do
      ContentfulClient.get_recipe('5jy9hcMeEgQ4maKGqIOYW6').title
    end

    it 'returns the title of the recipe', :vcr do
      expect(subject).to eq('Tofu Saag Paneer with Buttery Toasted Pita')
    end
  end

  describe '#image_url' do
    subject do
      ContentfulClient.get_recipe('5jy9hcMeEgQ4maKGqIOYW6').image_url
    end

    it 'returns the image url of the recipe', :vcr do
      expect(subject).to match(%r{^https://})
    end
  end
end
