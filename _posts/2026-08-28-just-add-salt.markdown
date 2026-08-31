---
layout: post
title: "Just Add Salt"
date: 2026-08-28
description: "Storing a password as-is is never the move. Salt helps."
tags: [api]
---

<p class="subtitle">bcrypt, salt, all the things</p>

![desk setup with a neon cyberpunk scene on the monitor above stacked books](/assets/img/posts/desktop.jpg)

I just added authentication to Cyberpunk Library (and it's now called Media Log, idk what happened there). The part that matters most is what happens to the password the second it hits my server. Pow.

It never gets stored as-is. Ever.

**Hashing isn't encryption.** Encryption is reversible, if you have the key, you get the original text back. Hashing isn't. A password goes through a hash function and comes out as a fixed-length string that can't be turned back into the original. My server never needs to "read" your password again, it only needs to check if a new attempt produces the same hash as the one on file.

**Salt stops the shortcut.** If two people use the same password sans-salt, their hashes would look identical. That's a problem because attackers keep giant precomputed tables of common password hashes ("rainbow tables") and they can look up a match instantly. Salt is random data mixed in before hashing so the same password produces a completely different hash for every user. This is where bcrypt comes in handy.

**The hook does the work.** In my user model, I added a `pre('save')` hook that hashes the password before it's written to the database, so it doesn't matter where in my code a user gets created, the hashing always happens. I don't have to remember to call it manually every time, which is exactly the kind of thing I'd forget. Even if I did it a million times.

**Comparing later matters.** Login hashes the password the user just typed and compares that new hash to the one already saved. `bcrypt.compare()` does it in a way that resists timing attacks, which is not something you want to try to DIY.

Ok so none of this is exotic. It's standard practice on literally every serious app of whatever size. The habit that matters is doing it by default so that it's already muscle memory when it needs to count!
