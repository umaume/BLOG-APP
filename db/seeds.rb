# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create test users
Rails.logger.debug "Creating test users..."

# Create first user
user1 = User.find_or_create_by(email: "alice@example.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
  u.name = "Alice Johnson"
  u.bio = "Tech enthusiast and blogger. Love writing about web development and design."
  u.website = "https://alice-blog.com"
end

# Create second user
user2 = User.find_or_create_by(email: "bob@example.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
  u.name = "Bob Smith"
  u.bio = "Full-stack developer sharing insights on programming and technology trends."
  u.website = "https://bobdev.io"
end

# Create third user
user3 = User.find_or_create_by(email: "charlie@example.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
  u.name = "Charlie Brown"
  u.bio = "Digital nomad writing about travel, coding, and remote work experiences."
end

Rails.logger.debug { "Created #{User.count} users" }

# Create sample posts
Rails.logger.debug "Creating sample posts..."

posts_data = [
  {
    user: user1,
    title: "Getting Started with Ruby on Rails",
    content: "Ruby on Rails is a powerful web application framework that makes it easy to build modern web applications. In this post, I'll share my journey learning Rails and some tips for beginners.\n\nRails follows the convention over configuration principle, which means you spend less time configuring and more time building features that matter to your users.\n\nSome key benefits of Rails:\n- Rapid development\n- Strong community\n- Excellent documentation\n- Rich ecosystem of gems",
  },
  {
    user: user1,
    title: "CSS Grid vs Flexbox: When to Use Each",
    content: "Both CSS Grid and Flexbox are powerful layout systems, but they serve different purposes. Understanding when to use each one is crucial for modern web development.\n\nFlexbox is perfect for one-dimensional layouts - either rows or columns. It's great for:\n- Centering items\n- Distributing space between items\n- Aligning items along an axis\n\nCSS Grid excels at two-dimensional layouts where you need to control both rows and columns simultaneously.",
  },
  {
    user: user2,
    title: "My Journey into Full-Stack Development",
    content: "Starting as a front-end developer, I recently made the transition to full-stack development. Here's what I learned along the way.\n\nThe backend was initially intimidating, but breaking it down into smaller concepts made it manageable:\n- Understanding HTTP requests and responses\n- Learning about databases and data modeling\n- Grasping server-side logic and APIs\n\nThe most rewarding part has been seeing how the frontend and backend work together to create complete applications.",
  },
  {
    user: user2,
    title: "Building REST APIs with Ruby on Rails",
    content: "Rails makes it incredibly easy to build robust REST APIs. With built-in support for JSON responses and RESTful routing conventions, you can have an API up and running in minutes.\n\nKey concepts for Rails APIs:\n- Using rails-api mode for leaner applications\n- Serializers for consistent JSON output\n- Authentication strategies (JWT, sessions)\n- Error handling and status codes\n- API versioning strategies",
  },
  {
    user: user3,
    title: "Remote Work Best Practices",
    content: "After working remotely for 3 years, I've learned valuable lessons about productivity, communication, and work-life balance.\n\nEssential tips for remote work success:\n- Set up a dedicated workspace\n- Establish clear boundaries between work and personal time\n- Over-communicate with your team\n- Use the right tools for collaboration\n- Take regular breaks and step away from the screen\n\nThe freedom to work from anywhere is amazing, but it requires discipline and good habits.",
  },
  {
    user: user3,
    title: "Digital Nomad Tech Stack",
    content: "As a digital nomad developer, having the right tech stack is crucial for productivity while traveling.\n\nMy essential tools:\n- MacBook Pro for development\n- Portable monitor for extra screen space\n- Noise-cancelling headphones\n- VPN for secure connections\n- Cloud storage for file backup\n- Project management tools like Notion\n\nThe key is keeping your setup lightweight but powerful enough to handle any development task.",
  },
]

posts_data.each do |post_data|
  Post.find_or_create_by(
    title: post_data[:title],
    user: post_data[:user]
  ) do |p|
    p.content = post_data[:content]
    p.published = true
  end
end

Rails.logger.debug { "Created #{Post.count} posts" }

# Create some sample comments
Rails.logger.debug "Creating sample comments..."

posts = Post.published.includes(:user)
users = [ user1, user2, user3 ]

comments_data = [
  { post: posts.first, user: user2, body: "Great introduction to Rails! This really helped me understand the framework better." },
  { post: posts.first, user: user3, body: "Thanks for sharing your experience. Looking forward to more Rails content!" },
  { post: posts.second, user: user2, body: "Excellent breakdown of Grid vs Flexbox. I always struggled with when to use which." },
  { post: posts.third, user: user1, body: "Congrats on making the transition! Your journey sounds similar to mine." },
  { post: posts.third, user: user3, body: "Full-stack development is so rewarding. Great insights!" },
]

comments_data.each do |comment_data|
  Comment.find_or_create_by(
    post: comment_data[:post],
    user: comment_data[:user],
    body: comment_data[:body]
  )
end

Rails.logger.debug { "Created #{Comment.count} comments" }

# Create some likes
Rails.logger.debug "Creating sample likes..."
posts.each do |post|
  users.sample(rand(1..2)).each do |user|
    Like.find_or_create_by(post: post, user: user) unless post.user == user
  end
end

Rails.logger.debug { "Created #{Like.count} likes" }

Rails.logger.debug "Seed data creation complete!"
Rails.logger.debug { "Users: #{User.count}" }
Rails.logger.debug { "Posts: #{Post.count}" }
Rails.logger.debug { "Comments: #{Comment.count}" }
Rails.logger.debug { "Likes: #{Like.count}" }
