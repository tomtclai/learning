const users = [
  {
    caption: "Facebook",
    image: "img/logos/facebook.svg",
    infoLink: "https://www.facebook.com",
    pinned: true
  },
  {
    caption: "Messenger",
    image: "img/logos/messenger.svg",
    infoLink: "https://messenger.com",
    pinned: true
  },
  {
    caption: "WOW air",
    image: "img/logos/wowair.svg",
    infoLink: "https://wowair.com",
    pinned: true
  },
  {
    caption: "BeOpinion",
    image: "img/logos/beopinion.svg",
    infoLink: "https://beopinion.com",
    pinned: true
  },
  {
    caption: "Mesopo",
    image: "img/logos/mesopo.svg",
    infoLink: "https://mesopo.ai",
    pinned: true
  },
  {
    caption: "Social Tables",
    image: "img/logos/socialtables.svg",
    infoLink: "https://www.socialtables.com",
    pinned: true
  },
  {
    caption: "Ahrefs",
    image: "img/logos/ahrefs.svg",
    infoLink: "https://ahrefs.com",
    pinned: true
  },
  {
    caption: "Astrocoders",
    image: "img/logos/astrocoders.svg",
    infoLink: "https://astrocoders.com",
    pinned: true
  },
  {
    caption: "Appier",
    image: "img/logos/appier.svg",
    infoLink: "https://appier.com",
    pinned: true
  },
  {
    caption: "Aesthetic Integration",
    image: "img/logos/aesthetic-integration.svg",
    infoLink: "https://www.imandra.ai",
    pinned: true
  }
];

const examples = [
  {
    name: "Hacker News",
    image: "img/examples/hn.png",
    link: "https://github.com/reasonml-community/reason-react-hacker-news",
  },
  {
    name: "TodoMVC",
    image: "img/examples/todomvc.png",
    link: "https://github.com/reasonml-community/reason-react-example/tree/master/src/todomvc",
  }
]

let reasonHighlightJs = require('reason-highlightjs');

const siteConfig = {
  title: "ReasonReact" /* title for your website */,
  tagline: "All your ReactJS knowledge, codified.",
  url: "https://reasonml.github.io/reason-react" /* your github url */,
  editUrl: "https://github.com/reasonml/reason-react/tree/master/docs/",
  translationRecruitingLink: "https://crowdin.com/project/reason-react",
  baseUrl: "/reason-react/" /* base url for your project */,
  projectName: "reason-react",
  headerLinks: [
    { doc: "installation", label: "Docs" },
    { doc: "playground", label: "Try" },
    { doc: "simple", label: "Examples" },
    { doc: "community", label: "Community" },
    { blog: true, label: "Blog" },
    { languages: true },
    { search: true },
    { href: "https://github.com/reasonml/reason-react", label: "GitHub" },
  ],
  users,
  examples,
  onPageNav: 'separate',
  scripts: ['/reason-react/js/pjax-api.min.js'],
  /* path to images for header/footer */
  headerIcon: "img/reason-react-white.svg",
  footerIcon: "img/reason-react-white.svg",
  favicon: "img/reason-react-favicon.png",
  /* colors for website */
  colors: {
    primaryColor: "#48a9dc",
    // darkened 10%
    secondaryColor: "#2F90C3",
  },
  // no .html suffix needed
  cleanUrl: true,
  highlight: {
    theme: 'atom-one-light',
    hljs: function(hljs) {
      hljs.registerLanguage('reason', reasonHighlightJs)
    }
  },
  algolia: {
    apiKey: "55156da6520de795d3a2c2d23786f08e",
    indexName: "react-reason",
    algoliaOptions: {
      facetFilters: ["lang:LANGUAGE"]
    }
  },
};

module.exports = siteConfig;
