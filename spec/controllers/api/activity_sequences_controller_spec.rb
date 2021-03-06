require 'rails_helper'

RSpec.describe Api::ActivitySequencesController, type: :controller do
  let(:response_body) { JSON.parse(response.body) }
  let(:first_body) { response_body[0] }

  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  describe 'GET #index' do
    context 'returns http no content' do
      it 'returns no content' do
        get :index

        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end

      it 'returns no content with activity sequence in draft' do
        create :activity_sequence, status: :draft

        get :index

        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end
    end

    context 'returns http success' do
      before do
        create :activity_sequence, status: :published
      end

      it 'returns http success' do
        get :index

        expect(response.content_type).to eq('application/json')
        expect(response).to be_successful
      end

      it 'return valid JSON all filters' do
        get :index

        expect(first_body['id']).to be_present
        expect(first_body['slug']).to be_present
        expect(first_body['title']).to be_present
        expect(first_body['main_curricular_component']).to be_present
        expect(first_body['estimated_time']).to be_present
        expect(first_body['status']).to be_present
        expect(first_body['number_of_activities']).to be_present
        expect(first_body['image_attributes']).to be_present
        expect(first_body['year']).to be_present
        expect(first_body['knowledge_matrices']).to be_present
        expect(first_body['learning_objectives']).to be_present
        expect(first_body['sustainable_development_goals']).to be_present
      end

      it 'return valid image attributes JSON' do
        get :index

        expect(first_body['image_attributes']).to be_present
        expect(first_body['image_attributes']['default_url']).to be_present
        expect(first_body['image_attributes']['default_size']).to be_present
      end

      it 'return valid knowledge matrices JSON' do
        get :index

        expect(first_body['knowledge_matrices']).to be_present
        expect(first_body['knowledge_matrices'][0]['sequence']).to be_present
        expect(first_body['knowledge_matrices'][0]['title']).to be_present
      end

      it 'return valid learning objectives JSON' do
        get :index

        expect(first_body['learning_objectives']).to be_present
        expect(first_body['learning_objectives'][0]['code']).to be_present
        expect(first_body['learning_objectives'][0]['color']).to be_present
      end

      it 'return valid sustainable development goals JSON' do
        get :index

        expect(first_body['sustainable_development_goals']).to be_present
        expect(first_body['sustainable_development_goals'][0]['name']).to be_present
        expect(first_body['sustainable_development_goals'][0]['icon_url']).to be_present
      end

      it 'return valid main_curricular_component' do
        get :index

        expect(first_body['main_curricular_component']['name']).to be_present
        expect(first_body['main_curricular_component']['color']).to be_present
      end
    end
  end

  describe 'GET #show' do
    let(:activity) { create :activity }
    let(:sustainable_development_goal) { create :sustainable_development_goal }
    let(:axis) { create :axis }
    let(:activity_sequence) do
      create :activity_sequence,
             activity_ids: [activity.id],
             axis_ids: [axis.id]
    end

    context 'returns http no content' do
      it 'returns no content' do
        get :show, params: { slug: 'invalid-slug' }

        expect(response).to be_successful
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'returns http success' do
      it 'returns http success' do
        get :show, params: { slug: activity_sequence.slug }

        expect(response.content_type).to eq('application/json')
        expect(response).to be_successful
      end

      it 'return valid JSON all filters' do
        get :show, params: { slug: activity_sequence.slug }

        expect(response_body['slug']).to be_present
        expect(response_body['title']).to be_present
        expect(response_body['year']).to be_present
        expect(response_body['main_curricular_component']).to be_present
        expect(response_body['estimated_time']).to be_present
        expect(response_body['status']).to be_present
        expect(response_body['books']).to be_present
        expect(response_body['image_attributes']).to be_present
        expect(response_body['presentation_text']).to be_present
        expect(response_body['curricular_components']).to be_present
        expect(response_body['knowledge_matrices']).to be_present
        expect(response_body['learning_objectives']).to be_present
        expect(response_body['sustainable_development_goals']).to be_present
        expect(response_body['activities']).to be_present
      end

      it 'return valid knowledge matrices JSON' do
        get :show, params: { slug: activity_sequence.slug }

        expect(response_body['knowledge_matrices']).to be_present
        expect(response_body['knowledge_matrices'][0]['sequence']).to be_present
        expect(response_body['knowledge_matrices'][0]['title']).to be_present
      end

      it 'return valid learning objectives JSON' do
        get :show, params: { slug: activity_sequence.slug }

        expect(response_body['learning_objectives']).to be_present
        expect(response_body['learning_objectives'][0]['code']).to be_present
        expect(response_body['learning_objectives'][0]['description']).to be_present
        expect(response_body['learning_objectives'][0]['color']).to be_present
      end

      it 'return valid curricular components JSON' do
        get :show, params: { slug: activity_sequence.slug }

        expect(response_body['curricular_components']).to be_present
        expect(response_body['curricular_components'][0]['name']).to be_present
      end

      it 'return valid sustainable development goals JSON' do
        get :show, params: { slug: activity_sequence.slug }

        expect(response_body['sustainable_development_goals']).to be_present
        expect(response_body['sustainable_development_goals'][0]['id']).to be_present
        expect(response_body['sustainable_development_goals'][0]['name']).to be_present
        expect(response_body['sustainable_development_goals'][0]['icon_url']).to be_present
        expect(response_body['sustainable_development_goals'][0]['sub_icon_url']).to be_present
      end

      it 'return valid main curricular component JSON' do
        get :show, params: { slug: activity_sequence.slug }

        expect(response_body['main_curricular_component']).to be_present
        expect(response_body['main_curricular_component']['name']).to be_present
        expect(response_body['main_curricular_component']['color']).to be_present
      end

      it 'return valid activities JSON' do
        get :show, params: { slug: activity_sequence.slug }

        expect(response_body['activities']).to be_present
        expect(response_body['activities'][0]['image_attributes']).to be_present
        expect(response_body['activities'][0]['title']).to be_present
        expect(response_body['activities'][0]['estimated_time']).to be_present
      end

      it 'return valid axes JSON' do
        get :show, params: { slug: activity_sequence.slug }

        expect(response_body['axes']).to be_present
        expect(response_body['axes'][0]['id']).to be_present
        expect(response_body['axes'][0]['description']).to be_present
        expect(response_body['axes'][0]['curricular_component']).to be_present
      end
    end
  end
end
