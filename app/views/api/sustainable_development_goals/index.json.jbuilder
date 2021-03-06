json.array! @sustainable_development_goals do |sustainable_development_goal|
  json.id sustainable_development_goal.id
  json.sequence sustainable_development_goal.sequence
  json.name sustainable_development_goal.name
  json.icon variant_url(sustainable_development_goal.icon, :icon)
  json.sub_icon url_for(sustainable_development_goal.sub_icon)
  json.color sustainable_development_goal.color
end
