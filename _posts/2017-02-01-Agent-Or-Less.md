---
layout: blog
title: Agent or Less
---
## To agent or not
This can be a very heated debate, and I see merits to both sides. So I'm just going to lay out the ground work for those that don't know the game is being played, as well as maybe help people see that both sides have reason to exist, even if they still want to kill them.

## What is an agent
The generally accepted use for the term agent, is when a larger multi-system design/tool requires an active piece of software on the "client" side of the relationship. This would be like the IRS requiring an agent at your house to perform a tax audit. They can't trust you to just give up reliable information on your own, so they send an agent that ensures the IRS gets what they want (and sometimes more, ha!).

## Why we hate agents
Well from the above example, it's obvious. They only add to make the situation more complex. And if the issue is trust, why can't you design the system _right_ to begin with? A famous piece of agent software is the Nagios monitoring agent, which gathers facts about a local system to report to the Nagios server. The irony is that there's little that this agent collects that couldn't also be collected from snmp. And guess what? SNMP is faster, by a good margain. It's also simpler in many ways, at least from an architecting standpoint where you want design freedom.

## Why we love agents
Generally speaking, they just work. By having software that runs on the client, we can design and compile for known supported systems. This leads to coheasion accross platforms. In the nagios example, you don't have to be concerned with what OID hard drive free space is, you just ask how much free space there is. With nagios most of the SNMP magic is handled by plug scripts, which causes people to forget all the work that goes into that magic, and how beyond help they'll be if the plug doesn't work for the system they wanted to monitor. Agents solve this by the supplier saying "this installs on windows" and it just works (in theory).

## Why the fuss
For the most part, there doesn't need to be a huge debate, except there's this pesky thing about organization and standards. Administrators hate snowflakes, because everything unique requires unique attention. You either use agents, or you avoid them. The problem with agents is that they can be very heavy handed for a task, leading to piles of waste when added up across a large scale environment, while managing things without agents can get beyond complex depending upon the tasks required.

## Where I draw lines
I try to take a bit more abstracted mindset to the conversation. I don't like anything that requires my eyeballs more than in the design phase. So the more I can automate the boostrapping process the better. Sometimes that means using an agent, but sometimes surprisingly not. The main thing I don't mind using an agent for, is anything regarding security/system management. Logs are a good example. Log gathering is a huge task, and you don't want to rely on systems holding that information, since by the time you need them it might be too late, and the system might either be irrepairable, or compromised. And agent that sends logs off to a central place in an indexed or ingestable manner is much easier to scale than a single or cluster of machines munching accross the network looking for logs. Also, if you ever want to refactor a running machine, versus deployin new every time, an agent that checks desired versus actual configurattion is worthwhile. Examples would be Puppet or Chef. The inverse of that is ansible which functions agent-less and is a great boostrapping tool, though does a far better at "documentation in code" when it comes to what you want things to be, versus what they are (since there's no guarentee that a host is actually continually up to date correctly as verifed by the IRS auditor, or I mean, agent).

## Conclusion
Agents suck. But they're a necessary evil many times. Do all you can to architect them away from your machines, but don't be surprised when the shiny new thing being rammed down from above requires one. Sometimes shiny/fancy/revolutionary comes with a price until it becomes something "system level" that can be abstracted away and trusted by the OS to handle correctly.

