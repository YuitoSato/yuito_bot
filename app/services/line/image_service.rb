module Line
  class ImageService
    attr_reader :binary

    def initialize(binary)
      @binary = binary
    end

    def execute
      description =
        GoogleCloudVisionService.new(binary).execute
          .try(:first)
          .try(:fetch, 'labelAnnotations')
          .try(:first)
          .try(:fetch, 'description')
      text = description ? "多分、、#{description}っすかね。" : 'ちょっと何かわからないっすw'
      {
        type: 'text',
        text: text
      }
    end
  end
end
