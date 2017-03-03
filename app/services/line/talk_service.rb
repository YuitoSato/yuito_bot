module Line
  class TalkService
    attr_reader :text

    def initialize(text)
      @text = text
    end

    def execute
      keyphrase =
        YahooKeyphraseService.new(text)
          .execute
          .try(:first)
          .try(:fetch, 'Keyphrase') ||
        YahooMAService.new(text)
          .execute
          .select{|word| word['pos'] == '形容詞' ||
            word['pos'] == '感動詞' ||
            word['pos'] == '副詞'}
          .first
          .try(:fetch, 'surface')

      text      = keyphrase ? keyphrase + 'っすね' : 'ちょっと何言ってるか分からないっすw'
      text.insert(0, 'つまり') if text.length > 26

      {
        type: 'text',
        text: text
      }
    end
  end
end
