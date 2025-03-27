# iOS Developer Candidate Code Challenge


<img src="https://github.com/tschmidt6/Morty-Character-Dex/blob/main/SimulatorScreen.gif" width=50% height=50%>

## Introduction
Congratulations on making it to the next phase of the interview process! This code challenge will help us evaluate your skills as an iOS developer.

We’d like you to spend no more than **3 hours** on this. We understand this is a significant time commitment, and we appreciate your effort. 

You’ll be creating a simple application from scratch. In a follow-up interview, you’ll demonstrate the working app and walk a small group of iOS developers through your code. They’ll ask questions about your approach to solving coding challenges while developing this application.

Good luck!

## Rules
- You **must** write all of the code yourself (excluding open-source libraries or auto-generated code).
- The app must be written in **Swift**. SwiftUI is required for the UI.
- Use any architecture, patterns, or techniques you prefer.
- You may use the internet for help as you normally would.
- You can use any open-source libraries.
- If you need clarification, contact the person who sent you this challenge.
- **Time limit: 3 hours.**

## Task
Create an iPhone application that allows a user to search for characters from the **Rick and Morty API**.

The UI should consist of:
- A **search bar** at the top.
- A **list** below it to display the search results.
- When a user types in the search bar, characters matching the search string should appear in the list.
- The list should display each character's **name, species, and image**.

### API Endpoint
Use the following API endpoint to fetch characters:
```
https://rickandmortyapi.com/api/character/?name=rick
```
Replace `rick` with the user's search input.
No API key is required.

## Acceptance Criteria
- The search results must come from the API above.
- The search results should update **as the user types**.
- Show a **progress indicator** while fetching data.
- **Tapping on a character** should navigate to a **detail view** containing:
  - Character **name** (as a title)
  - Character **image** (full width)
  - **Species**
  - **Status**
  - **Origin**
  - **Type** (only if available)
  - **Formatted created date**
- Include **at least one unit test**.

## Submission Instructions
Once finished, **create a public repository** for your project and email us the link. Any publicly accessible repository (e.g., GitHub) is fine.

## Extra Credit (Optional)
If you finish the core requirements with time left, consider adding:
- **Accessibility support**:
  - VoiceOver support
  - Dynamic text support
- Additional **unit tests**
- **UI tests**
- **Landscape orientation support**
- **Share button** in the detail view (to share the character's image and metadata)
- **Image transition animation** (from list to detail view)
- **Filtering options** (e.g., by status, species, type)

## What We’re Looking For
During the code review, we’ll evaluate:
- **Communication skills**
- **Safe Swift code**
- **Good coding practices** (industry-standard patterns and techniques)
- **Well-formatted and readable code**
- **Efficient API calls** (no blocking the main thread)
- **Memory management** (no retain cycles or memory leaks)
- **Proper error handling**
- **Understanding of Apple’s Human Interface Guidelines**

You should be able to explain every line of code and justify your choices during the review.

