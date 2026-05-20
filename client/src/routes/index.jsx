import { Navigate, Route, Routes } from 'react-router-dom';
import GetStarted from '../pages/GetStarted.jsx';

function AppRoutes() {
  return (
    <Routes>
      <Route path="/" element={<GetStarted />} />
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  );
}

export default AppRoutes;