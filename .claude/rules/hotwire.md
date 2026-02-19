---
paths:
  - "app/javascript/**/*"
  - "app/views/**/*"
---

# Hotwire Conventions (Turbo + Stimulus)

## Turbo Frames — Partial Page Updates

Use for scoped page updates (navigation within a section):

```erb
<%# app/views/spots/_spot.html.erb %>
<%= turbo_frame_tag dom_id(@spot) do %>
  <div class="card">
    <h2><%= @spot.name %></h2>
    <%= link_to "Edit", edit_spot_path(@spot) %>
  </div>
<% end %>

<%# app/views/spots/edit.html.erb %>
<%= turbo_frame_tag dom_id(@spot) do %>
  <%= render "form", spot: @spot %>
<% end %>
```

Rules:
- Each frame needs a unique DOM ID (`dom_id(@model)` helper)
- Clicks inside a frame replace only that frame's content
- Links outside a frame must use `data-turbo-frame: "_top"` or `data: { turbo_frame: dom_id(@spot) }`
- Use `<%= turbo_frame_tag "id", src: url %>` for lazy loading

## Turbo Streams — Real-Time Multi-Element Updates

Use for broadcasting changes to multiple parts of the page:

```ruby
# app/controllers/comments_controller.rb
def create
  @comment = @spot.comments.build(comment_params.merge(user: current_user))
  if @comment.save
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @spot }
    end
  else
    render :new, status: :unprocessable_entity
  end
end
```

```erb
<%# app/views/comments/create.turbo_stream.erb %>
<%= turbo_stream.append "comments" do %>
  <%= render @comment %>
<% end %>
<%= turbo_stream.update "comment-form" do %>
  <%= render "form", spot: @spot, comment: Comment.new %>
<% end %>
```

Available actions: `append`, `prepend`, `replace`, `update`, `remove`, `before`, `after`

Broadcasting (ActionCable):
```ruby
# app/models/comment.rb
after_create_commit -> { broadcast_append_to @spot, target: "comments" }
after_destroy_commit -> { broadcast_remove_to @spot }
```

## Stimulus Controllers — JavaScript Behavior

Keep controllers focused on single responsibility:

```javascript
// app/javascript/controllers/map_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]
  static values = { lat: Number, lng: Number, apiKey: String }

  connect() {
    this.initMap()
  }

  disconnect() {
    // Clean up if needed
  }

  initMap() {
    const map = new google.maps.Map(this.containerTarget, {
      center: { lat: this.latValue, lng: this.lngValue },
      zoom: 14,
    })
    new google.maps.Marker({ position: { lat: this.latValue, lng: this.lngValue }, map })
  }
}
```

Naming conventions:
- File: `app/javascript/controllers/map_controller.js`
- HTML: `data-controller="map"`
- Target: `container` → `data-map-target="container"`
- Value: `lat` → `data-map-lat-value="35.6762"`
- Action: `initMap` → `data-action="click->map#initMap"`

Rules:
- One controller = one responsibility
- Use `connect()`/`disconnect()` for lifecycle management
- Use `values` for data from server (not embedded JS variables)
- Avoid `querySelector` — use Stimulus targets instead
- Don't use jQuery; use native DOM or Stimulus APIs

## Best Practices

- Prefer Turbo over custom `fetch`/AJAX code
- Use `turbo_frame_tag` helpers, not raw `<turbo-frame>` HTML
- Use `data: { turbo_confirm: "確認メッセージ" }` for destructive actions
- Test Turbo interactions in system specs with Capybara (`:js` metadata)
- Check existing Stimulus controllers in `app/javascript/controllers/` before creating new ones
