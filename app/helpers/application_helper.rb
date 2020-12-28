module ApplicationHelper
  def sortable(column, header = nil)
    header ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to header, request.params.merge({sort: column, direction: direction, page: nil}), {class: css_class }
    # Article.joins(:user).order(surname: :asc)
  end
end
