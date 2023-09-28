module AwsService
  class ImageRecognition < ApplicationService

    def initialize(image_key)
      @image = image_key
    end

    def call
      return [] if @image.blank?
      client = Aws::Rekognition::Client.new
      attrs = {
        image: {
          s3_object: {
            bucket: ENV['AWS_DEFAULT_BUCKET'],
            name: @image
          },
        },
        max_labels: 5
      }
      response = client.detect_labels attrs
      generate_hash(response.labels)
    end


    private
      def generate_hash(labels)
        hash_labels = []
        labels.each do |label|
          puts "Label:      #{label.name}"
          puts "Confidence: #{label.confidence}"
          puts "Instances:"
          label['instances'].each do |instance|
            box = instance['bounding_box']
            puts "  Bounding box:"
            puts "    Top:        #{box.top}"
            puts "    Left:       #{box.left}"
            puts "    Width:      #{box.width}"
            puts "    Height:     #{box.height}"
            puts "  Confidence: #{instance.confidence}"
          end
          puts "Parents:"
          label.parents.each do |parent|
            puts "  #{parent.name}"
          end
          puts "------------"
          puts "Generating Object"

          # -- Generating object label descriptions --
          # object parents
          label_parents = label.parents.reduce([]) do |accum, parent|
            accum << parent.name
          end.to_sentence
          parents_desc = label_parents.present? ? ", which represents a #{label_parents}" : ''

          # object categories
          label_categories = label.categories.reduce([]) do |accum, category|
            accum << category.name
          end
          categories_sentence = label_categories.to_sentence
          categories_desc = categories_sentence.present? ? ", which could be categorized as #{categories_sentence}. " : ''

          # object aliases
          label_aliases = label.aliases.reduce([]) do |accum, label_alias|
            accum << label_alias&.name
          end.to_sentence
          aliases_desc = label_aliases.present? ? "It can be identified as #{label_aliases} " : ''

          # object scales
          bounding_box = label['instances'].first
          if bounding_box.present?
            label_scale = bounding_box['bounding_box']
            scale = { wide: (label_scale.width * 100).floor, large: (label_scale.height * 100).floor }
            @scale_desc = scale[:wide].present? && scale[:large].present? ? "It is measured as #{scale[:wide]} percent wide "\
              "and #{scale[:large]} percent large inside the image. " : ''
          end


          # -- Generating data Hashes --
          hash_labels << {
            name: label.name,
            description: "It is #{label.name}#{parents_desc}. " + categories_desc + aliases_desc + "#{@scale_desc}",
            categories: label_categories,
            certainty: label.confidence,
          }
        end
        hash_labels
      end

  end
end
