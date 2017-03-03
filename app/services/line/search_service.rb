module Line
  class SearchService
    attr_reader :text

    def initialize(text)
      @text = text
    end

    def execute
      res = GoogleCustomSearchApi.search(text)
        .items
        .try(:first)

      image = res.pagemap
        .cse_thumbnail
        .try(:first)
        .try(:fetch, 'src') if res['cse_thumbnail']

      {
        'type': 'template',
        'altText': 'this is a buttons template',
        'template': {
            'type': 'buttons',
            'thumbnailImageUrl': image,
            'title': res.title,
            'text': res.snippet[0, 60],
            'actions': [
                {
                  'type': 'uri',
                  'label': 'Click here',
                  'uri': res.link
                }
            ]
        }
      }
    end
  end
end
