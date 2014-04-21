module GrapeDoc
  class GithubMarkdownFormatter
    def generate_resource_doc(resource)
      title = "### #{resource.resource_name}\n"

      documents = resource.documents.map do |document|
        path = "#{document.http_method} #{document.path}"
        description = document.description

        parameters = document.params.map do |parameter|
          next if parameter.field.nil? or parameter.field.empty?
          param = "* `#{parameter.field}"
          if parameter.field_type
            param << " <#{parameter.field_type.downcase}>` "
          else
            param << "` "
          end
          param << '*required* ' if parameter.required
          param << parameter.description if parameter.description
          param
        end.join("\n") if document.params

        route = "**#{path.split('/').last.humanize.camelcase}** `#{path}`"
        route << "\n\n#{description}" unless description.blank?
        route << "\n\nParameters: \n\n#{parameters}" unless parameters.blank?
        route << "\n\n"

      end.join
      return "" if documents.nil? or documents.empty?
      "#{title}\n\n\n#{documents}\n"
    end
  end
end
