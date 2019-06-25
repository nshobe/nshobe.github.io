---
layout: post
title: Puppet Sucks
---
Okay, maybe not really entirely. Hell, I _did_ go to puppetconf 2016 and had a well enough time. But there's some larger points to be made, and while I feel puppet is my top choice for configuration management currently, we should keep honest about the pitfalls in order to improve the breed.

## Pros
Since you're _supposed_ to say nice things to a person before suggesting there might be a crack in the candy kingdom, I supposed I should do the same when it comes to something that could offend a whole *host* of people.

1. If puppet doesn't do it, you likely don't _need_ it as part of your CI:CD process for your OS platform.
1. There's a huge community of people using puppet who will gladly give a helping hand.
1. Lots of maturity in the product has yeilded much direct support from most vendors.
1. Very flexible regarding how you implement the stack.

## Cons
I'll keep this brief....

...not.

1. Documentation Sucks. I mean, the horror stories of the past make what they have seem _okay_ but that's like being glad that your awkward uncle Leo is dry now and allowed to attend family functions. There's no continuity and there really needs to be a manual to go along with the docs, you know, like those "guides to the character" helper books common among the more popular fantasy novel series. I shouldn't need to google weather or not I'm reading applicable documentation before applying example logic.
1. Which leads to this: Lack of difinitive starting points. Okay, I get that all organizations/groups like different ice cream, and frequent different bars, and might even run different Linux distros, but I'd argue that 90% of what people want to manage is the same, and though the underlying modules that do those things might change slightly, we're all roughly after the same end goal. Giving me a "roles and profiles" document does little to really get me going.
1. The community is dumb. Sorry. There it is. I can find piles of modules people have shared that are doing things terribly wrong, haven't been updated in _years_ and people keep suggesting you use it. It seems like half of the noob questions show evidence that people aren't even beginning to comprehend the docs, and once you've asscended the inital brutal curve that is puppet, you feel like a lonely lord in a castle wondering if other kings out there want to come out and play.
1. It's phat. I know it's an agent, so it won't be light. But wow. Don't run this on old hardware. Don't run it on sparc. On x86 it's well optimized and will run just fine, but some of this older ruby code is not well suited to the variety of hardware you likely want to run it on. These agents need to be completely re-written in C (or python, knock knock) and stat.
1. It's phat. The server too! I can't believe how hard it is to run a server and agents in VMs locally on a laptop. For something that doesn't scale well it should at least be lean.
1. Wait, it doesn't scale? Yeah, they just annoiced "HA" capabilities, but even in fail-over mode they still can't let you make changes to your code. It just hobbles your report data along in case such data is mission critical to business logic you're relying on. There's no load-balancing or clustering allowing multi-site configuration so you can have a front end reverse proxy to your puppet services. This is a major problem, and one they recognize, but a major blocker for some (especially as evidence from people I talked to who are deploying puppet on the six figure node scale).

## Fixing the plane with no landing gear
There's certainly some solutions to these problems, and there's no point in complaining if I'm not ready to do something about it.

Here's where I'd start.

1. Make the next major version, puppet 5, a hard departure. Forget backwards compatability. There's too much at stake that needs work.
1. Hiera as a brand name needs to drop. It's data. It's puppet data. The tool used is irrelevant to buyers/users.
1. Speaking of, naming and versioning of stuff needs some major work. Drop "mcollective" even if that means buidling a wrapper cli tool. It all needs to say puppet.
1. And not only that, it all needs to be the same version, even if there's no change. All new releases should cause the same number increase in the full stack, so that you can log into a host and say "what version is puppet" and not wonder about the underlying pieces.
1. The community needs more clarity on what's code (logic), and what's data. Data by default needs a home that has two sides, one that will be versioned with git merges, and one that is static aside from merges, so that things you always want different across environments stay different. I shouldn't have to cherry pick git merges because I want to specify my postgres password in hiera and refuse to us an %{environment} layer in my data (which would break branch-to-environment logic).

## Conclusion
For an agent based configuration managment tool, puppet is currently the best and also best poised for future impact. I hope they can start getting some of this stuff right. I've got too many grey hairs for a 20-something year old already.

