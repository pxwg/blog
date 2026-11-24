interface MathJaxRuntime {
  startup: { promise: Promise<void> };
  typesetPromise(elements: Element[]): Promise<void>;
}

export function renderArticleMath(prose: Element) {
  const assetPath = `${import.meta.env.BASE_URL.replace(/\/$/, '')}/vendor/mathjax`;
  const browser = window as Window & { MathJax?: unknown };
  browser.MathJax = {
    // Load only the components needed for display and screen readers.
    loader: { load: ['input/mml', 'output/chtml', 'a11y/assistive-mml'] },
    startup: { typeset: false },
    options: { enableAssistiveMml: true },
    output: {
      font: 'mathjax-newcm',
      fontPath: `${assetPath}/mathjax-newcm`,
      displayOverflow: 'scroll',
    },
  };

  const script = document.createElement('script');
  script.src = `${assetPath}/startup.js`;
  script.addEventListener('load', async () => {
    const mathJax = browser.MathJax as MathJaxRuntime;
    try {
      await mathJax.startup.promise;
      await mathJax.typesetPromise([prose]);
    } catch (error) {
      console.error('MathJax could not render the article formulas.', error);
    }
  }, { once: true });
  document.head.append(script);
}
