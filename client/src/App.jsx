import { Container, Navbar, Nav } from 'react-bootstrap';
import './App.css';

function App() {
  return (
    <div className="app-wrapper">
      {/* Navigation */}
      <Navbar bg="dark" data-bs-theme="dark" sticky="top" className="navbar-custom">
        <Container>
          <Navbar.Brand href="#" className="fw-bold fs-5">
            <span className="brand-icon">⚡</span> Dagsap App
          </Navbar.Brand>
          <Nav className="ms-auto">
            <Nav.Link href="#home">Home</Nav.Link>
            <Nav.Link href="#features">Features</Nav.Link>
            <Nav.Link href="#about">About</Nav.Link>
          </Nav>
        </Container>
      </Navbar>

      {/* Main Content */}
      <main className="main-content">
        <Container>
          <section className="hero-section text-center py-5 my-5">
            <div className="hero-badge mb-3">
              <span className="badge bg-info text-dark">Welcome to Template</span>
            </div>
            <h1 className="hero-title mb-3">
              Build Amazing Apps
            </h1>
            <p className="hero-subtitle text-muted mb-4">
              Modern React template with Bootstrap styling and best practices
            </p>
            <div className="cta-buttons">
              <button className="btn btn-primary btn-lg me-3 btn-custom">
                Get Started
              </button>
              <button className="btn btn-outline-secondary btn-lg btn-custom">
                Learn More
              </button>
            </div>
          </section>

          {/* Features */}
          <section id="features" className="features-section py-5 my-5">
            <h2 className="text-center mb-5 section-title">Features</h2>
            <div className="row g-4">
              <div className="col-md-4">
                <div className="feature-card">
                  <div className="feature-icon bg-primary">📦</div>
                  <h5 className="mt-3">Modern Stack</h5>
                  <p className="text-muted">React 19, Vite, Bootstrap for fast development</p>
                </div>
              </div>
              <div className="col-md-4">
                <div className="feature-card">
                  <div className="feature-icon bg-success">🔐</div>
                  <h5 className="mt-3">Secure Auth</h5>
                  <p className="text-muted">JWT authentication with best practices</p>
                </div>
              </div>
              <div className="col-md-4">
                <div className="feature-card">
                  <div className="feature-icon bg-info">⚡</div>
                  <h5 className="mt-3">Fast & Ready</h5>
                  <p className="text-muted">Production-ready setup with clear structure</p>
                </div>
              </div>
            </div>
          </section>

          {/* Info Box */}
          <section className="info-section py-5 my-5">
            <div className="info-box">
              <h3 className="mb-3">📝 Next Steps</h3>
              <ul className="list-unstyled">
                <li className="mb-2">✓ Update <code>package.json</code> with your app name</li>
                <li className="mb-2">✓ Configure <code>.env</code> variables</li>
                <li className="mb-2">✓ Read documentation in README files</li>
                <li className="mb-2">✓ Start building your application!</li>
              </ul>
            </div>
          </section>
        </Container>
      </main>

      {/* Footer */}
      <footer className="footer bg-dark text-light py-4 mt-5">
        <Container className="text-center">
          <p className="mb-0">© 2024 Your App Name. Built with React & Bootstrap.</p>
        </Container>
      </footer>
    </div>
  );
}

export default App;
