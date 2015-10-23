module TagsHelper
  def toggle_tag_on_path(tag)
    if active_tag?(tag)
      remove_tag_from_path(tag)
    else
      add_tag_to_path(tag)
    end
  end

  def tag_classes(tag)
    classes = ["tag-toggle", tag]

    if active_tag?(tag)
      classes << "is-active"
    end

    classes
  end

  def add_tag_to_path(tag)
    current_tags = tags_to_filter_by + [tag]
    { tags: current_tags.join(",") }
  end

  def remove_tag_from_path(tag)
    current_tags = tags_to_filter_by - [tag]
    { tags: current_tags.join(",") }
  end

  def active_tag?(tag)
    tags_to_filter_by.include?(tag)
  end
end
