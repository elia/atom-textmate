require 'native'
require 'pp'

Atom = Native(`atom`)

def $stdout.write(string)
  `console.info(#{string})`
  nil
end

def $stderr.write(string)
  `console.error(string)`
  nil
end

class File
  def self.realpath(pathname, dir_string = nil, cache = nil, &block)
    pathname = join(dir_string, pathname) if dir_string
    if block_given?
      `
      #{__fs__}.realpath(#{pathname}, #{cache}, function(error, realpath){
        if (error) #{raise error.message}
        else #{block.call(`realpath`)}
      })
      `
    else
      `#{__fs__}.realpathSync(#{pathname}, #{cache})`
    end
  end

  def self.__path__
    @path ||= `OpalNode.node_require('path')`
  end

  def self.basename(path, ext = undefined)
    `#{__path__}.basename(#{path}, #{ext})`
  end

  def self.dirname(path)
    `#{__path__}.dirname(#{path})`
  end

  def self.join(*paths)
    __path = __path__
    `#{__path}.join.apply(#{__path}, #{paths})`
  end
end

module WorkspaceView
  def workspace_view
    @workspace_view ||= Native(`atom.workspaceView`)
  end
end

class TextMate
  native_class
  include WorkspaceView

  class OpenFavsView
    include WorkspaceView

    def initialize(parent)
      @parent = parent
    end

    def add_projects &add_project
      # pp [:add_projects, ENV['HOME']]
      links = Dir["#{ENV['HOME']}/Library/Application Support/TextMate/Favorites/*"]
      # pp [:links, links]
      links.each do |link|
        # pp [:link, link]
        File.realpath(link) do |realpath|
          p [link, realpath]
          link_name = File.basename(link)
          if link_name.start_with? '[DIR] '
            Dir[File.join(realpath, '*')].each do |project_path|
              project = Project.new(project_path)
              # pp [:project, project]
              add_project.call(project)
            end
          else
            project = Project.new(realpath)
            # pp [:project_real, realpath]
            add_project.call(project)
          end
        end
      end
    end

    def append_element
      @element ||= begin
        workspace_view.append <<-HTML
          <div class="select-list fuzzy-finder overlay from-top" callattachhooks="true">
            <div class="editor editor-colors mini is-focused" tabindex="-1" callattachhooks="true" style="font-size: 16px;">
              <div class="gutter" callattachhooks="true">
                <div class="line-numbers" style="display: block; padding-top: 0px; padding-bottom: 0px; top: 0px;">
                  <div class="line-number line-number-0 cursor-line cursor-line-no-selection" data-buffer-row="0">1<div class="icon-right">
                  </div>
                </div>
              </div>
            </div>
            <div class="scroll-view">
              <div class="overlayer" style="height: 25px; min-width: 465px; top: 0px;">
                <div class="cursor idle" callattachhooks="true" style="top: 0px; left: 0px;">&nbsp;</div>
              </div>
              <div class="lines" style="height: 25px; min-width: 465px; padding-top: 0px; padding-bottom: 0px; top: 0px;">
                <div class="line">&nbsp;</div>
              </div>
              <div class="underlayer" style="height: 25px; min-width: 465px; top: 0px;">
                <input class="hidden-input" style="top: 0px; left: 0px;">
                <div class="selection" callattachhooks="true">
                </div>
              </div>
            </div>
            <div class="vertical-scrollbar">
              <div style="height: 25px;">
              </div>
            </div>
          </div>
          <div class="error-message" style="display: none;">
          </div>
          <div class="loading" style="display: none;">
            <span class="loading-message">
            </span>
            <span class="badge">
            </span>
          </div>
          <ol class="list-group">
            <!-- DAh LISt HerE -->
          </ol>
          </div>
        HTML
      end
    end

    def list
      @list ||= Native(workspace_view.find('.select-list .list-group'))
    end

    class Project
      def initialize(path)
        @path = path
      end

      attr_reader :path
      attr_accessor :selected

      def basename
        @basename ||= File.basename(path)
      end

      def dirname
        @dirname ||= File.dirname(path)
      end

      alias :selected? :selected
    end

    def render
      append_element
      p [:self, self]
      p [:list, list]
      _list = list
      add_projects do |project|
        # not sure why but here `this` is the global object (`window`)
        _list.append <<-HTML
          <li class="two-lines #{:selected if project.selected?}">
            <div class="primary-line file icon icon-file-text">#{project.basename}</div>
            <div class="secondary-line path no-icon">#{project.dirname}</div>
          </li>
        HTML
      end
    end
  end



  def activate state
    workspace_view.command 'textmate:open-favs', -> { workspace_view.append view.render }

    # state = Native(state)
    # @view = TextMateView.new(state[:textmateViewState])
  end

  def view
    @view ||= OpenFavsView.new(workspace_view)
  end

  def deactivate
    # view.destroy
  end

  def serialize
    # {textmateViewState: view.serialize}.to_n
    {}.to_n
  end

  native_alias :activate, :activate
  native_alias :deactivate, :deactivate
  native_alias :serialize, :serialize
end
