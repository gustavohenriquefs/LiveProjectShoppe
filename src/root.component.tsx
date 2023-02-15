// @ts-ignore
import { Header } from "@shoppe/util-ui";
// @ts-ignore
import { useStore } from "@shoppe/util-state";

export default function Root(props) {

  const store = useStore();

  return (
    <Header/>
  )
}
