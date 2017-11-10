#-- encoding: UTF-8
#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2017 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2017 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

module OpenProject
  module TextFormatting
    include ::OpenProject::TextFormatting::Truncation

    # Formats text according to system settings.
    # 2 ways to call this method:
    # * with a String: format_text(text, options)
    # * with an object and one of its attribute: format_text(issue, :description, options)
    def format_text(*args)

      # Forward to the legacy text formatting for textile syntax
      if Setting.text_formatting == 'textile'
        return Formatters::Textile::LegacyTextFormatting.format_text(*args)
      end

      options = args.last.is_a?(Hash) ? args.pop : {}
      case args.size
      when 1
        object = options[:object]
        text = args.shift
      when 2
        object = args.shift
        attr = args.shift
        text = object.send(attr).to_s
      else
        raise ArgumentError, 'invalid arguments to format_text'
      end
      return '' if text.blank?

      project = options.delete(:project) { @project || object.try(:project) }
      Renderer.format_text text,
                           options.merge(
                             object: object,
                             project: project
                           )
    end
  end
end
