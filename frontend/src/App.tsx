import { Routes, Route } from 'react-router-dom'
import { Helmet } from 'react-helmet-async'
import Layout from './components/Layout/Layout'
import Dashboard from './pages/Dashboard'
import HealthMetrics from './pages/HealthMetrics'
import AIInsights from './pages/AIInsights'
import Analytics from './pages/Analytics'
import Profile from './pages/Profile'
import Login from './pages/Login'
import NotFound from './pages/NotFound'
import ProtectedRoute from './components/Auth/ProtectedRoute'

function App() {
  return (
    <>
      <Helmet>
        <title>Metabolitica September - Health Analytics Platform</title>
        <meta name="description" content="Advanced health analytics platform with AI-powered insights for better health outcomes" />
      </Helmet>
      
      <Routes>
        <Route path="/login" element={<Login />} />
        
        <Route path="/" element={
          <ProtectedRoute>
            <Layout />
          </ProtectedRoute>
        }>
          <Route index element={<Dashboard />} />
          <Route path="health-metrics" element={<HealthMetrics />} />
          <Route path="ai-insights" element={<AIInsights />} />
          <Route path="analytics" element={<Analytics />} />
          <Route path="profile" element={<Profile />} />
        </Route>
        
        <Route path="*" element={<NotFound />} />
      </Routes>
    </>
  )
}

export default App
