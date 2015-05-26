class Search
  def self.search(query, option=nil)
    return [] unless query.present?

    escaped_query = Riddle::Query.escape(query)

    if indices.include? option.to_sym
      index_name = "#{ option }_core"
      ThinkingSphinx.search escaped_query, indices: [index_name]
    else
      ThinkingSphinx.search escaped_query
    end
  end

  def self.options_for_select
    search_options.invert.to_a
  end

  def self.search_options
    {
      question_with_associations: 'questions, including all associations',
      all: 'all objects',
      question: 'only questions',
      answer: 'only answers',
      comment: 'only comments',
      user: 'only users'
    }
  end

  def self.indices
    @indices ||= search_options.keys - [:all]
  end

  private_class_method :search_options, :indices
end
