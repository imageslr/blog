class DetailsTagBlock < Liquid::Block

  def initialize(tagName, markup, tokens)
    super
    @summary = markup.strip
  end

  def render(context)
    text = super
    %Q[<details markdown="1"><summary>#{@summary}</summary>#{text}</details>]
  end

  Liquid::Template.register_tag "details", self
end