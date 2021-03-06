module GrapeDoc
  class DOCGenerator
    attr_accessor :resources,
                  :formatter,
                  :single_file,
                  :formatter_class
    def initialize(resource_path,formatter_class)
      begin
        require resource_path
        self.formatter_class = formatter_class
        self.load
      rescue LoadError => ex
        puts "#{ex}"
      end
    end

    def init_formatter
      if self.formatter.nil?
        case formatter_class
        when 'github'
          GrapeDoc::GithubMarkdownFormatter.new
        else
          GrapeDoc::MarkdownFormatter.new
        end
      end
    end

    def load
      self.resources = Grape::API.subclasses.map do |klass|
        resource = APIResource.new(klass)
        if resource.documents.nil? or resource.documents.count.zero?
          nil
        else
          resource
        end
      end.compact.sort_by(&:resource_name)
    end

    def generate
      doc_formatter = init_formatter
      doc_dir = "#{Dir.pwd}/grape_doc"
      FileUtils.mkdir_p(doc_dir)

      self.resources.each do | resource |
        File.open(File.join(doc_dir, "#{resource.resource_name}.md"), 'w') {|f| f.write doc_formatter.generate_resource_doc(resource) }
      end
    end
  end
end
