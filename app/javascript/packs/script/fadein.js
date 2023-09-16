// スクロールで表示したい要素
  const fadein = document.querySelectorAll(".fadein");
  const options = {
    rootMargin: '0px',
  };

  const observer = new IntersectionObserver(showElement,options);

  fadein.forEach((fadein) => {
    observer.observe(fadein);
  });

  // 要素が表示されたら実行する動作
  function showElement(entries) {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        // 要素にactiveクラスを付与
        entry.target.classList.add("active");
      }
    });
  }