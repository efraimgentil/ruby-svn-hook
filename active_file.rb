require "fileutils"
require "yaml"

module ActiveFile

    def save
        @new_record = false
        FileUtils.mkdir_p self.class.database_dir

        File.open( "#{self.class.database_dir}/#{@id}.yml" , "w" ) do |f|
            f.puts serialize
        end
    end

    def destroy
        unless @destroyed or @new_record
            @destroyed = true
            FileUtils.rm "#{self.class.database_dir}/#{@id}.yml"
        end
    end

    module ClassMethods

        def fields(*fields_name) 
            fields_name.each do |name| 
                field(name)
            end
        end

        def field(name)
            get = %Q{
                def #{name}
                    @#{name}
                end                
            }

            set = %Q{
                def #{name}=(value)
                    @#{name} = value
                end
            }
            self.class_eval get
            self.class_eval set
        end

        def find(id)
            file = "#{database_dir}/#{id}.yml"
            raise DocumentNotFound , 
               "File #{file} not found", caller unless File.exists?( file )

            return load_by_file file
        end

        def all
            result = []
            files = Dir.glob("#{database_dir}/*.yml")
            files.each{|file|
                result.push load_by_file(file)
            }
            return result
        end

        def next_id
           Dir.glob("#{database_dir}/*.yml").size + 1
        end

        def database_dir
            @dir_name ||= "db/#{self.name.downcase}"
            @dir_name
        end

        private 
            def load_by_file(file)
                YAML.load File.open( file , "r" )
            end

    end

    def self.included(base)
        base.extend ClassMethods
        base.class_eval do
            attr_accessor :id , :destroyed , :new_record

            def initialize(parameters = {})
                super()
                @id = self.class.next_id
                @destroyed = false
                @new_record = true

                parameters.each do |key, val|
                    instance_variable_set "@#{key}", val
                end
            end
        end
    end

    private 

        def serialize
            YAML.dump self
        end

end