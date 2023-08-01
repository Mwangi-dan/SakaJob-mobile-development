// Script to generate a random fun fact about me
// whenever button is clicked on the page
const funFacts = [
    'I love playing the piano',
    "I love dogs, but I'm allergic to them",
    'I can speak 3 languages: English, Swahili and Kikuyu',
    "I'm passionate about photography",
    'I love to travel',
    'I enjoy reading',
    'I once nearly drowned',
    'I am subtly competitive',
    "I'm a recovering introvert",
    'I love the Hunger Games Franchise',
    'I love to sing',
    'I can learn really fast'
];

const funFactButton = document.querySelector('#fun-fact-btn');
const funFactContainer = document.querySelector('#fun-fact-container');
const funFactText = document.querySelector('#fun-fact-text');

// The algorithm should never repeat a fun fact until all fun facts have been displayed
// The algorithm should never display the same fun fact twice in a row
// The algorithm should never display the same fun fact twice in a session

const listLength = funFacts.length;

funFactButton.addEventListener('click', () => {
    let randomNumber = Math.floor(Math.random() * listLength);
    while (randomNumber === funFactButton.previousRandomNumber) {
        randomNumber = Math.floor(Math.random() * listLength);
    }
    funFactText.textContent = funFacts[randomNumber];
    funFactButton.previousRandomNumber = randomNumber;
});

