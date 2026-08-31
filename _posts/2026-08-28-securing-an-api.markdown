---
layout: post
title: "Four Things My API Yelled at Me About"
date: 2026-08-28
description: "The stuff I forget every single deploy, and the fixes I keep bookmarking then losing again."
tags: [api]
---

<p class="subtitle">stuff I forget every time, no matter how many times I've deployed</p>

![desk setup with a neon cyberpunk scene on the monitor above stacked books](/assets/img/posts/desktop.jpg)

![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=282a36)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat-square&logo=nodedotjs&logoColor=f8f8f2)
![Express](https://img.shields.io/badge/Express-000000?style=flat-square&logo=express&logoColor=f8f8f2)
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=flat-square&logo=mongodb&logoColor=f8f8f2)
![Heroku](https://img.shields.io/badge/Heroku-430098?style=flat-square&logo=heroku&logoColor=f8f8f2)
![Vercel](https://img.shields.io/badge/Vercel-000000?style=flat-square&logo=vercel&logoColor=f8f8f2)

I just put together a small MERN app for tracking books, movies, and games called [Cyberpunk Library](https://cyberpunk-library.vercel.app). Nothing fancy, but deploying it reminded me of the same handful of things that trip me up basically every time, no matter how many times I do this.

By the way nobody remembers all of this cold, and that's what keeps me motivated. We're all on Stack Overflow at some point (at least I am!). Here's four things I tripped on:

**1. Env vars have to actually be gitignored.** My connection string has a real username and password sitting in it. It goes in `.env`, and `.env` goes in `.gitignore` _before_ the first commit. I've made this mistake before, and trying to clean up later can be messy because even after it's "clean" it's in the history whether you like it or not.

**2. Heroku won't touch your `.env` file.** I know this and I _still_ forget it. Locally, everything just works off `.env`. On Heroku, none of that exists unless you set it directly with `heroku config:set`. If you skip it the app crashes on boot with a Mongoose error that doesn't obviously point back to "you forgot the config var."

**3. Atlas blocks everything by default.** This one's a good instinct even when it's annoying. Atlas only lets connections through from IPs you've explicitly allowed. Heroku dynos don't have a fixed IP, so the fix is allowing `0.0.0.0/0` which kinda sounds like turning security off, but it's not. The real gatekeeping is still your database username and password. The IP list is just one more layer, and it's the layer that has to flex for cloud hosting to work at all.

**4. CORS errors are not the browser's fault.** It reads that way in the moment, a bit dramatic; but it's actually the browser refusing to let some other site quietly read your API using someone else's saved session. Adding `cors()` on your Express server is you telling the browser "yes, other origins are allowed to talk to me," which is something you want since your frontend and your API live on two different URLs.

None of this is hard once you've hit it. It's just easy to forget between projects. I'm considering implementing a system that consists of a ridiculous assortment of sticky notes with each reminder stuck to my monitors so that I can pluck them off as I complete each step. I also might consider integrating this little API into my actual Ultimate Cyberpunk Media List for management. Who knows.

Anyway, thanks for reading!
