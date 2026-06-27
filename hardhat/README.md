# Ritual Bounty Judge System

## Overview
This project implements a secure `Commit-Reveal` bounty system to prevent plagiarism.

## Lifecycle
1. **Commit Phase:** Participants submit a `keccak256(answer, salt, sender, bountyId)` hash.
2. **Reveal Phase:** After the deadline, participants reveal their original answer and salt.
3. **Judging:** The contract verifies the commitment against the revealed data.
4. **AI/Human Judge:** Valid submissions are processed via Ritual's execution layer.

## Reflection
In a bounty system, the commitment hash must be public to ensure transparency. However, the actual answer must remain hidden until the deadline to prevent plagiarism. AI is ideal for the first stage of evaluation (filtering and scoring logic), while a human judge is necessary for final decisions on complex, subjective quality metrics. This hybrid approach ensures both fairness and scalability.