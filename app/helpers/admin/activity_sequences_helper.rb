module Admin
  module ActivitySequencesHelper
    def learning_objectives_collection(main_curricular_component_id)
      learning_objectives = LearningObjective.where(curricular_component_id: main_curricular_component_id)
      learning_objectives.collect do |lo|
        [lo.code_and_description, lo.id]
      end
    end

    def knowledge_matrices_collection
      KnowledgeMatrix.all.order('sequence ASC').collect do |km|
        [km.sequence_and_title, km.id]
      end
    end

    def sustainable_development_goals_collection
      SustainableDevelopmentGoal.all.order('sequence ASC').collect do |sds|
        [sds.sequence_and_name, sds.id]
      end
    end

    def remote_request(type, path, target_tag_id, params = {})
      "$.#{type}('#{path}',
                 {#{params.collect { |p| "#{p[0]}: #{p[1]}" }.join(', ')}},
                 function(data) {$('##{target_tag_id}').html(data);}
       );"
    end
  end
end