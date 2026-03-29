# vitalpet

YHack 2026

## Inspiration

Not remembering how you had been doing at the doctor's office not only puts you at the risk of embarrassment but also misdiagnosis and undertreatment. Making a daily note of yourself is too easy, and yet none of us do it. Why? 

## What it does

A digital-pet whose well-being is connected to you consistently makes you intentional. The app is designed to be as less invasive as possible. The questions are adaptive. You feel great. Good to know. You feel feverish might I just ask the temperature if it's convenient, you feel feverish and fatigued hmm I have a few more question. And if you're not in mood to click buttons you can just type how you're feeling and formalize it into a structured record. Now on every doctor visit you can share how you've been for the last 30 days. No more misdiagnosis and undertreatment.

## How we built it

A fully contained mobile application built using Flutter and powered by Gemma.

## Challenges we ran into

Running Gemma models on iPad and iPhone. The flutter_gemma library took us a long time to integrate correctly. There were a lot of configuration on the iOS SDK side that we had to get right, and then the format in which model weights were available.

## Accomplishments that we're proud of

Ran LLM inference on A16 chips on our first iOS app ever! That's big, exciting, and exhausting.

## What we learned

1. LLM inference on the edge is very costly in terms of resources as well as in terms of integration
2. Each layer of abstraction in dev tools makes a few things easy but many things too error-prone and finicky.
