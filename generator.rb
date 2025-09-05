require 'json'

def write_problems
  data = JSON.parse(File.read('LEETCODE.json'))
  template_md = File.read('mintlify-problemtemplate.mdx')
  problem_summary_metadata = []
  difficulty_emoji = {"Medium"=>"🧀", "Easy"=>"🧩", "Hard"=>"❗️"}
  difficulty_level = {"Medium"=>1, "Easy"=>0, "Hard"=>2}
  base_path = "problems-index/all-problems"

  def filter_question_content(str)
    str.gsub('<strong>Output:</strong>', '<br/> <strong>Output:</strong>')
    .gsub('<strong>Explanation:</strong>', '<br/> <strong>Explanation:</strong>')
    .gsub('<pre>', '').gsub('</pre>', '')
    .gsub('<p>&nbsp;</p>','')
    .gsub(/<!-- .*? -->/, '') # Example of removed tag: <!-- notionvc: e5d6f4e2-d20a-4fbd-9c7f-22fbe52ef730 -->
    .gsub('{', '&lbrace;').gsub('}', '&rbrace;')
    # .gsub('<code>', '`').gsub('</code>', '`')
  end

  def update_question_note(str)
    return "No notes for this problem" if str.nil? || str.empty?
    # for mdx, handle < and > to replace them
    str.gsub('<', '&lt;').gsub('>', '&gt;').gsub('{', '&lbrace;').gsub('}', '&rbrace;').strip
  end

  problem_keys = data.first.keys - ['questionId', 'question_content', 'question_difficulty', 'question_topics', 'question_note']

  data.each do |problem|
    output_md = template_md.dup
    problem_keys.each { |key| output_md.gsub!("{${#{key}}$}", problem[key])}
    output_md.gsub!("{${question_content}$}", filter_question_content(problem['question_content']))
    output_md.gsub!("{${question_note}$}", update_question_note(problem['question_note']))
    output_md.gsub!("{${difficulty_emoji}$}", difficulty_emoji[problem['question_difficulty']])
    slug = problem['url'][/problems\/(.*?)\/description/, 1]
    write_path = "#{base_path}/#{slug}"

    File.write("#{write_path}.mdx", output_md)

    problem_summary_metadata << {
      questionId: problem['questionId'],
      diff: problem['question_difficulty'],
      diff_level: difficulty_level[problem['question_difficulty']],
      topics: problem['question_topics'],
      top_level_link: "* [#{difficulty_emoji[problem['question_difficulty']]} #{problem['title']}](leetcode-problems/#{slug}.md)",
      docs_json_path: write_path
    }
  end;

  problem_summary_metadata = problem_summary_metadata.map {|x| [x[:questionId], x]}.to_h
end

def update_docs_json_for_all_problems(problem_metadata)
  docs_json_data = JSON.parse(File.read('docs.json'))
  nested_keys_path = ["navigation", "tabs",  1,  "groups", 0, "pages", 1]
  parent_hash = docs_json_data.dig(*nested_keys_path)
  parent_hash["pages"] = problem_metadata.values.sort_by{|x| x[:diff_level] }.map{|x| x[:docs_json_path] }
  File.write("docs.json", JSON.pretty_generate(docs_json_data))
end

problem_summary_metadata = write_problems()
update_docs_json_for_all_problems(problem_summary_metadata)

# topics counter
topic_h = Hash.new {|h,k| h[k]=[]};
problem_summary_metadata.values.each { |p| p[:topics].each {|x| topic_h[x]<<p[:questionId] } }

# Custom Topics sections
topical_menu = "";
# All topics, difficulty wise, top-priority-topics,
# all topics is just section-wise page containing links for all topic pages
# top-priority topics contains links to topic page for top topics etc.

# top-topics to be shown
topics_to_show = {'dynamic-programming'=> 'Dynamic Programming',
 'graph'=> 'Graph',
 'heap-priority-queue'=> 'Heap - PriorityQueue',
 'bit-manipulation'=> 'Bit Manipulation',
 'greedy'=> 'Greedy',
 'monotonic-stack'=> 'Monotonic Stack',
 'two-pointers'=> 'Two Pointer',
 'union-find'=> 'Union Find'}

# topics_to_show.each do |slug, topic_name|
#   `mkdir gitbook/#{slug}`
#   `touch gitbook/#{slug}/README.md`
#   topical_menu+= "* [#{topic_name}](#{slug}/README.md)\n"
#   topic_h[slug].sort_by{ |x| problem_summary_metadata[x][:diff_level] }.each { |qid|
#     topical_menu+= "  #{problem_summary_metadata[qid][:top_level_link]}\n"
#   }
# end

# File.write("TOPICS_SECTIONS.md", topical_menu)

# def update_docs_json_for_topics(problem_metadata)
#   docs_json_data = JSON.parse(File.read('docs.json'))
#   NESTED_KEY_PATH = ["navigation", "tabs",  1,  "groups", 0, "pages", 1]
#   parent_hash = docs_json_data.dig(*NESTED_KEY_PATH)
#   parent_hash["pages"] = problem_summary_metadata.values.sort_by{|x| x[:diff_level] }.map{|x| x[:docs_json_path] }
#   File.write("new_docs.json", docs_json_data)
# end
