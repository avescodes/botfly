require 'rubygems'
require 'botfly'
require 'fileutils'
require 'yaml'

config = YAML::load(ARGF.read) if ARGF

bot = Botfly.login(config["jid"],config["pass"]) do
  on.message.body(/^blame/) do |a|
    match = @body.match(/^blame (.*):(.*)$/)
    file = match[1]
    line = match[2].to_i

    project = "/Users/burke/src/jsgithistory"
    
    result=nil
    FileUtils.cd(project) do
      result = `git blame -p -L#{line},#{line} #{file}`
    end
    
    author = result.lines.find{|e|e=~/^author /}.sub(/author /,'').strip
    time   = Time.at(result.lines.find{|e|e=~/^author-time /}.sub(/author-time /,'').to_i)
    commit = result.lines.first.split(' ').first.strip
    
    reply "#{author}, #{time}, #{commit}"
  end
end

Thread.stop;loop
