import Typed from 'typed.js';

const loadDynamicBannerText = () => {
  new Typed('#banner-typed-text', {
    strings: ["Share your ideas to the world"],
    typeSpeed: 75,
    loop: false
  });
}

export { loadDynamicBannerText };
