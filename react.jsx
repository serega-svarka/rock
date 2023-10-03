npm install ethers axios 
import React, { useState } from 'react';
import { ethers } from 'ethers';
import axios from 'axios';

const RockPaperScissors = ({ contractAddress }) => {
    const [selectedMove, setSelectedMove] = useState('');
    const [result, setResult] = useState('');

    const playGame = async () => {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(contractAddress, ['function play(uint8 _playerMove) payable'], signer);

        try {
            const transaction = await contract.play(selectedMove, { value: ethers.utils.parseEther('0.0001') });
            await transaction.wait();
            const response = await axios.get(`https://api.bscscan.com/api?module=account&action=txlist&address=${signer._address}&startblock=0&endblock=99999999&sort=desc&apikey=ETKHF7C3RTVQA7F`);
            setResult(response.data.result[0].status === "0x1" ? "You Win!" : "You Lose!");
        } catch (error) {
            setResult("Error occurred: " + error.message);
        }
    };

    return (
        <div>
            <h1>Rock-Paper-Scissors Game</h1>
            <label>Select your move:</label>
            <select onChange={(e) => setSelectedMove(parseInt(e.target.value))}>
                <option value="1">Rock</option>
                <option value="2">Paper</option>
                <option value="3">Scissors</option>
            </select>
            <button onClick={playGame}>Play</button>
            {result && <p>{result}</p>}
        </div>
    );
};

export default RockPaperScissors;
