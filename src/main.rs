use yew::prelude::*;
use web_sys::HtmlInputElement;

#[function_component]
fn App() -> Html {
    let counter = use_state(|| 0);
    let onclick = {
        let counter = counter.clone();
        move |_| {
            let value = *counter + 1;
            counter.set(value);
        }
    };


    let input_value = use_state(|| "".to_string());

    let oninput = {
        let input_value = input_value.clone();
        Callback::from(move |e: InputEvent| {
            let input: HtmlInputElement = e.target_unchecked_into();
            input_value.set(input.value());
        })
    };
    html! {
        <div>
            <button {onclick}>{ "+1" }</button>
            <p>{ *counter }</p>
            <input type="text" {oninput} value={(*input_value).clone()} />
            <p>{ format!("Current input: {}", *input_value) }</p>
        </div>
    }
}

fn main() {
    yew::Renderer::<App>::new().render();
}