# Peusapat

## Introduction

- Simple community ~~group chat~~ forum discussion.
- One room with category/tags. Maybe automatic catgorization to make easier to post something new. I'm talking about AI here ;)
- Ability to do anonimous post. Because Indonesian audience love to ask anonymously.
- It's not as sync as chat app, not as async as forum discussion. It's in the between.

### What it is not

It's not Discord, too complex.
It's not youtube community, it's multi directional forum discussion.

## Target Audience

- Me
- Content creator

## Jobs to be done

### Problems

- In the need to engage with audience that is not entirely private (telegram, discord)
- Group chat that is simple, not overloaded
- Simple group chat so audience can ask freely and fast
- Able to ask as anonymous as an option

## Functional Requirement

### Group Owner

- [x] As a group owner, I want to be able to sign up, sign in and sign out
- [x] As a group owner, I want to be able to create a new group
- [x] As a group owner, I want to be able to edit group
- [x] As a group owner, I want to be able to delete group
- [ ] As a group owner, I want to be able to list of owner's group

### Audience

- [x] As an audience, I want to be able to sign up, sign in and sign out
- [x] As an udience, I want to able to join group chat from url or qr code
- [x] As an audience, I want to able to send chat message to the group chat i've joined
- [ ] As an audience, I want to able to see chat messages from other audience in realtime fashion
- [x] Show date and time of post
- [x] Show community description
- [x] As an audience, I can peek the post before I decide to join conversation
- [ ] As an audience, I can create new community

- [x] Reply to post
  - ~~Using modal~~
  - ~~Or inline input text?~~
  - [x] Redirect to reply page
- [x] ~~Query post without parent id~~
- [ ] ~~Query post with parent id for each post~~
- [x] Add replies module
- [ ] ~~Breadcrumb navigation~~
- [x] Update copy in landingpage
- [x] Change UI language to english
- [x] Add border to reply textarea
- [x] Social login
  - [x] Remove user settings page
- [x] Dynamic avatar for user
- [ ] Create new community
- [x] Remove discussion/reply if community owner
- [ ] SEO stuff
- [ ] Count replies
- Like post
- Pin message
- Notification feature
  - Webmentions?

## Non-functional Requirement

- Use [Flowbite](https://flowbite.com/blocks/publisher/comments/)
- Name:
  - meupakat
  - DialogNest
  - Chorum
  - Charum

## Model

### Users

- name:string
- avatar:string

### Communities

- name:string
- logo:string -- optional
- description:text -- optional
- slug:string
- owner:references(users)

### Topics

- post:text
- parent_id:references(topics)
- user_id:references(users)

## Referensi

- https://once.com/campfire
- https://youtube.com/rizafahmi/community

## Getting Started

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
