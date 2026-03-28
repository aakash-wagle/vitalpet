import { createBrowserRouter } from "react-router";
import { Home } from "./pages/Home";
import { Pet } from "./pages/Pet";
import { History } from "./pages/History";
import { Report } from "./pages/Report";

export const router = createBrowserRouter([
  {
    path: "/",
    Component: Home,
  },
  {
    path: "/pet",
    Component: Pet,
  },
  {
    path: "/history",
    Component: History,
  },
  {
    path: "/report",
    Component: Report,
  },
]);
