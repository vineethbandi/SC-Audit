import { WavyBackground } from "@/components/ui/wavy-background";

export default function Header() {
  return (
    <WavyBackground className="max-w-4xl mx-auto pb-20">
      <p className="text-4xl md:text-4xl lg:text-7xl text-white font-bold inter-var text-center">
        <span className="bg-gradient-to-r from-purple-600 via-indigo-500 to-blue-500 bg-clip-text text-transparent text-shadow-lg animate-pulse">
          SC Audit
        </span>
        , <span className="text-transparent bg-clip-text bg-gradient-to-l from-pink-500 to-yellow-500">AI-Powered</span> Smart Contract Auditing
      </p>
      <p className="text-base md:text-2xl mt-4 text-white font-normal inter-var text-center">
        <span className="font-semibold text-pink-300 animate-bounce">Revolutionize</span> your smart contract auditing with <span className="text-transparent bg-clip-text bg-gradient-to-r from-green-400 to-blue-500 font-bold">AI</span>
      </p>
    </WavyBackground>
  );
}
