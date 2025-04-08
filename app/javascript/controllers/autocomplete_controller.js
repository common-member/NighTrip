import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]
  static values = { url: String }

  connect() {
    // console.log('✅ 正常にautocomplete_controllerが読み込まれました') //デバッグ用
    // console.log('📌 inputTarget:', this.inputTarget) //デバッグ用
    // console.log('📌 resultsTarget:', this.resultsTarget) //デバッグ用

    if (this.hasInputTarget) {
      this.inputTarget.addEventListener("input", this.search.bind(this));
      // console.log("🟢 イベントリスナー追加済み") //デバッグ用
    } else {
      // console.warn("⚠️ inputTarget が見つかりません") //デバッグ用
    }
  }

  async search() {
    // console.log('✅searchメソッドが呼ばれました') //デバッグ用

    try {
      const query = this.inputTarget.value;

      if (query.length < 2) {
        this.resultsTarget.innerHTML = "";
        return;
      }

      // console.log("[DEBUG] query:", query) //デバッグ用

      const response = await fetch(`${this.urlValue}?q=${encodeURIComponent(query)}`);
      const items = await response.json();

      // console.log("[DEBUG] items:", items) //デバッグ用

      this.resultsTarget.innerHTML = items.map(item =>
        `<li class="cursor-pointer px-4 py-2 hover:bg-gray-100" data-action="click->autocomplete#select" data-id="${item.id}">${item.name}</li>`
      ).join("");

    } catch (error) {
      console.error("❌ search中にエラーが発生しました:", error);
    }
  }

  select(event) {
    this.inputTarget.value = event.currentTarget.textContent;
    this.resultsTarget.innerHTML = "";
  }
}
