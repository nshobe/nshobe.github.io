---
layout: post
title: Best Puppeting Practices
tags: SysAdmin Puppet
---
## Why Start Here
Because you'll hate yourself _less_.

## Why is this important
Puppet isn't *just* a configuration management tool. It's actually not the best at that if you consider just a task => complete tool. Puppet's real power is that it's one of the better abstraction tools on the market. This means docs should _always_ be presented in a "this is how one _might_ do a thing" mentality. Thus the community has formed fairly strong opinions on how to structure your puppet environment, in order to keep abstraction layers similarly minded, regardless of state => goal of your environment.

## Layers
#### Resources
The core of all puppet code is resources. These are the lowest level items you're wanting to define. Most resources you ever write code for will use pre-defined functions of puppet code that are referred to as resource types. These are things like Users, SSHkeys, Files, Hosts, and on. There's literally 100+ and growing number of resource types built in. The most powerful part of built in types is that they're largely platform agnostic, meaning they just work everywhere without you understanding the difference between OSX, BSD, and Gentoo.
#### Class
Classes are ways to create "scope" of code. Something like a `mounts.pp` file is assumed to be creating mounts, and any supporting features for those mounts, like making sure to create the destination dir before trying to mount the underlying storage. Combine classes together to make a:
#### Module
Which is designed to be the lowest level "group" of classes that define resources that are aiming at the same goal. Using the above mounts example, you might have a "network sharing" module that defines your nfs mounts in your environment. Any type of thing you might need to configure, like the server, the client, mount points, mount options, etc can all be spread into applicable pieces (go ahead and call those classes) and brought together to be able to say "this does what it's called". It's very important that modules have TALL defined walls of what they manage. Don't make the mistake of thinking you should tune your partitions for your NFS server with your network sharing module. This could save you *days* or even *weeks* of bloody forehead battles with your desk.
#### Manifest
Just a pp file. All puppet code belongs in a pp file. Don't overthink it. You can stack manifests in almost any file/folder structure you want, as long as the underlying class names match.
#### Assembly Layers
This is my term, because the community terms conflict with other tool's communities terms (more on that later). But think about this: if your module, like the above network sharing module needs different parameters based upon which office you're in, or what floor of the building, etc, then you likely need a way to specify these different types of common denominators. Maybe you need different configurations for different levels of security within your orginzation. Nobody can answer _these_ questions for your organization in even the slightly amount of certainty. So you create classes that contain classes, that contain classes, that contain... I'll stop.

## Roles and Profiles
Oh for the love of god, not again...

...yeah, another roles and profiles discussion, because we're talking best practices. Some people are still not utilizing this concept at all, and others are just murdering it alltogether.

Let me make this simple: call them apples and bannanas, or apples and oranges. Or go really crazy and call them apples oranges and bannanas (I'll leave it up to you to decide who's who here). Point is this: They're ways to create name-space layers where you know what you're doing where.

#### Most people
Use profiles to assemble groups of modules that live in concert together that need variables definied in a varried fashion accross their structure. If `apt-get install apache2` just works as-is in 100% of your environment, then `include apache` will also just work and you can put that in something like a `profile::base` that gets applied in all places. But the reality, is that most of us have 90% overlap of configurations, and that 10% is nearly unique per-host. So we figure out what can be detected by puppet and auto-filled, and drop the remaining "needs done by hand" in some form of a database (uuung, more on that later). Then because it might take *more than a few* profiles to define what a host should be, we wrap that into a role. This way, your main site.pp file (which is the only place you're defining node resources, right?) can stay nice and clean with one role per entry, and some entries might even have regex or arrays to define multiple hosts that can be 100% the same, with the database picking up the few changes that make them unique.

#### But people
Are special unique snowflakes, oh wait no, that's machines. People get really hung up on the "but this machine is special and different" aspect, and most of the time you find out it's largely not as special as they think. So we create variables, that can be looked up in a table or maybe defined based upon something puppet knows, like ipaddress or domain.

## Hiera
So puppet introduced hiera as it's solution to the database problem. This is _great_ in the sense that it's easier to write yaml, versus ruby-esk puppet code, and highly configurable. Hiera has gotten better and better as puppet evolves, to the point that it's name should be removed entirely and part of the "puppet" name brand. Basically any time you use a ${variable} puppet checks it's facts, then checks the pp file you're in, then checks the module level hiera (if you have one) then checks the main environment's hiera location. What's greate is that puppet now gives us the capability to control merging behvior per-variable so if you want giant hashes that get merge across all your hiera files, or if you want definite "write a few lines and overwrite all and reset rest to defaults" hashes or arrays that's now doable, all at the same time, in the same module even!

## Putting it all together
Considering all these facets that make up most "organization" level setups, here's a skeleton that would work for most people:

[Roles(apples)] -> Define hosts (use one role per host, period!) <- applied either with site.pp or an ENC (foreman, puppet enterprise console, etc)

[Profiles] -> Define Roles (use liberally, pile them in, they won't care, if they get unweildly add oranges to those banannas) <- Should be the place to use your global hiera database to define variables as applied to varios profiles.

[Modules] -> Define how to do a thing. They should be either written by you, or the community (NOT BOTH, don't edit forge modules) <- Should be contained and not-cross talk managing things other modules also try to manage

[Resources] -> Most basic building blocks <- largely written by puppet, and when those fail, get good at the exec resource

## Common Mistakes (Maybe read this first? Sorry)
#### Node Resouces
Anytime you use `node [hostname] {...}` it should be in a site.pp file under [env]/manifests/site.pp. Nowhere else. Ever. Don't. Just. No.
#### Duplicate Resouces
Puppet doesn't like seeing the same resource twice in a compile catalog (the stack of code it eventually calculates a host should apply), and will get angry. You'll in turn get angry that you can't figure out how to do what you want in a different way. Answer: Use more variables, or figure out how to iterate with puppet code. Puppet now can do $var.each which is wonderful. Learn to use it. If it makes more sense, use the older define type model. I'd suggest staying away from `create_resources`.
#### Hardcoded Variables
All too often people create something they're applying like a module, but they've populated with data like you'd apply in a profile. This is an easy mistake to make if you're making a module that will get applied to _one_ host at the moment. Stop and think about what will happen if you apply the _same code_ to a second machine with a slightly different configuration. Will it break? Add more variables, even if there's only one possible answer to those variables for the time being.

## TLDR
Sorry, this has gotten long. I'll stop. This article will get linked to in further articles, and thus might get broken out or maybe even added to as needed. These are just some of the things I've had to learn the hard way, likely because I enjoy the pain or something sick like that. But if you can, learn from my mistakes, as I repeat things I heard but didn't understand when I first set off with puppet.
