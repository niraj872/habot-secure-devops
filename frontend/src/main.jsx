// Author: NIRAJ KR YADAV
// Email: Nirajyadav9466@gmail.com
// Phone: 7366913096

import React, { useState } from "react";
import { createRoot } from "react-dom/client";
import "./styles.css";

const API = "";

function App() {
  const [form, setForm] = useState({
    student_id: "STU-1001",
    student_name: "",
    age: "",
    has_learning_difficulty: true,
    requires_learning_support: true,
    consent_given: false,
    data_region: "IN-NCR"
  });

  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);

  function update(field, value) {
    setForm((current) => ({ ...current, [field]: value }));
  }

  async function submit(event) {
    event.preventDefault();
    setLoading(true);
    setResult(null);

    try {
      const response = await fetch(`${API}/api/onboarding/`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          ...form,
          age: Number(form.age)
        })
      });

      const data = await response.json();

      setResult({
        ok: response.ok,
        data
      });
    } catch (error) {
      setResult({
        ok: false,
        data: {
          error: "Backend connection failed. Make sure Django is running on port 8000."
        }
      });
    } finally {
      setLoading(false);
    }
  }

  return (
    <main className="page">
      <section className="card">
        <div className="header">
          <div>
            <p className="eyebrow">HABOT SECURE DEVOPS</p>
            <h1>Student Onboarding</h1>
            <p className="subtitle">
              Secure schema validation and deterministic DCYN decisioning.
            </p>
          </div>
          <span className="status">API â€¢ 8000</span>
        </div>

        <form onSubmit={submit}>
          <div className="grid">
            <label>
              Student ID
              <input
                value={form.student_id}
                onChange={(e) => update("student_id", e.target.value)}
                required
              />
            </label>

            <label>
              Student Name
              <input
                value={form.student_name}
                onChange={(e) => update("student_name", e.target.value)}
                required
              />
            </label>

            <label>
              Age
              <input
                type="number"
                min="1"
                max="120"
                value={form.age}
                onChange={(e) => update("age", e.target.value)}
                required
              />
            </label>

            <label>
              Data Region
              <input
                value={form.data_region}
                onChange={(e) => update("data_region", e.target.value)}
                required
              />
            </label>
          </div>

          <div className="checks">
            <label className="check">
              <input
                type="checkbox"
                checked={form.has_learning_difficulty}
                onChange={(e) =>
                  update("has_learning_difficulty", e.target.checked)
                }
              />
              Has learning difficulty
            </label>

            <label className="check">
              <input
                type="checkbox"
                checked={form.requires_learning_support}
                onChange={(e) =>
                  update("requires_learning_support", e.target.checked)
                }
              />
              Requires learning support
            </label>

            <label className="check consent">
              <input
                type="checkbox"
                checked={form.consent_given}
                onChange={(e) => update("consent_given", e.target.checked)}
              />
              Required consent provided
            </label>
          </div>

          <button disabled={loading}>
            {loading ? "Validating..." : "Validate Onboarding"}
          </button>
        </form>

        {result && (
          <div className={`result ${result.ok ? "success" : "error"}`}>
            <strong>{result.ok ? "Validation successful" : "Validation failed"}</strong>
            <pre>{JSON.stringify(result.data, null, 2)}</pre>
          </div>
        )}
      </section>
    </main>
  );
}

createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);




